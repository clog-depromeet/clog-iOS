//
//  Project+Template.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import ProjectDescription

extension Project {
    public static func configure(
        moduleType: ModuleType,
        product: Product,
        dependencies: [TargetDependency],
        interfaceDependencies: [TargetDependency] = [],
        packages: [Package] = [],
        hasTests: Bool = true,
        hasResources: Bool = false
    ) -> Project {
        
        var targets: [Target] = []
        var schemes: [Scheme] = []
        let configuration = AppConfiguration()
        
        switch moduleType {
        case .app:
            let appTarget = Target.target(
                name: configuration.projectName,
                destinations: configuration.destination,
                product: .app,
                bundleId: configuration.bundleIdentifier,
                deploymentTargets: configuration.deploymentTarget,
                infoPlist: .extendingDefault(with: configuration.infoPlist),
                sources: ["Sources/**"],
                resources: [.glob(pattern: "Resources/**", excluding: [])],
                entitlements: configuration.entitlements,
                dependencies: dependencies,
                settings: configuration.setting
            )
            targets.append(appTarget)
            
            let appScheme = Scheme.configureAppScheme(
                schemeName: configuration.projectName
            )
            schemes = appScheme
            
            return Project(
                name: configuration.projectName,
                organizationName: configuration.organizationName,
                packages: packages,
                settings: configuration.setting,
                targets: targets,
                schemes: schemes
            )
        case let .service(name):
            let serviceTargetName = "\(name)Service"
            
            let serviceTarget = Target.target(
                name: serviceTargetName,
                destinations: configuration.destination,
                product: product,
                bundleId: "\(configuration.bundleIdentifier).service.\(name.lowercased())",
                deploymentTargets: configuration.deploymentTarget,
                sources: ["Sources/**"],
                dependencies: dependencies
            )
            targets.append(serviceTarget)
            
            if hasTests {
                let testTargetName = "\(serviceTargetName)Tests"
                let testTarget = Target.target(
                    name: testTargetName,
                    destinations: configuration.destination,
                    product: .unitTests,
                    bundleId: "\(configuration.bundleIdentifier).service.\(name.lowercased()).test",
                    deploymentTargets: configuration.deploymentTarget,
                    sources: ["Tests/Sources/**"],
                    dependencies: [.target(name: serviceTargetName)]
                )
                targets.append(testTarget)
            }
            
            return Project(
                name: serviceTargetName,
                organizationName: configuration.organizationName,
                settings: configuration.commonSettings,
                targets: targets,
                schemes: schemes
            )
        case let .feature(name, type):
            let featureTargetName = "\(name)Feature"
            switch type {
            case .standard:
                let featureTarget = Target.target(
                    name: featureTargetName,
                    destinations: configuration.destination,
                    product: product,
                    bundleId: "\(configuration.bundleIdentifier).feature.\(name.lowercased())",
                    deploymentTargets: configuration.deploymentTarget,
                    sources: ["Sources/**"],
                    dependencies: dependencies
                )
                targets.append(featureTarget)
                
                if hasTests {
                    let testTargetName = "\(featureTargetName)Tests"
                    let testTarget = Target.target(
                        name: testTargetName,
                        destinations: configuration.destination,
                        product: .unitTests,
                        bundleId: "\(configuration.bundleIdentifier).feature.\(name.lowercased()).test",
                        deploymentTargets: configuration.deploymentTarget,
                        sources: ["Tests/Sources/**"],
                        dependencies: [.target(name: featureTargetName)]
                    )
                    targets.append(testTarget)
                }
                
                let featureScheme = Scheme.configureScheme(
                    schemeName: featureTargetName,
                    configurationName: configuration.name,
                    targetName: featureTargetName,
                    codeCoverageTargets: [featureTargetName]
                )
                schemes.append(featureScheme)
                
                return Project(
                    name: featureTargetName,
                    organizationName: configuration.organizationName,
                    settings: configuration.commonSettings,
                    targets: targets,
                    schemes: schemes
                )
            case .micro:
                return configureMicroFeatureProject(
                    configuration: configuration,
                    product: product,
                    name: featureTargetName,
                    organizationName: configuration.organizationName,
                    targets: targets,
                    dependencies: dependencies,
                    interfaceDependencies: interfaceDependencies
                )
            }
            
        case let .module(name, useDemo):
            let moduleTargetName = name
            let demoScheme: Scheme
            
            let moduleTarget = Target.target(
                name: name,
                destinations: configuration.destination,
                product: product,
                bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())",
                deploymentTargets: configuration.deploymentTarget,
                sources: ["Sources/**"],
                resources: hasResources ? ["Resources/**"] : [],
                dependencies: dependencies
            )
            targets.append(moduleTarget)
            
            if hasTests {
                let testTargetName = "\(name)Tests"
                let testTarget = Target.target(
                    name: testTargetName,
                    destinations: configuration.destination,
                    product: .unitTests,
                    bundleId: "\(configuration.bundleIdentifier).\(name.lowercased()).test",
                    deploymentTargets: configuration.deploymentTarget,
                    sources: ["Tests/Sources/**"],
                    dependencies: [.target(name: name)]
                )
                targets.append(testTarget)
            }
            
            if useDemo {
                let demoTargetName = "\(name)Demo"
                let demoTarget = Target.target(
                    name: demoTargetName,
                    destinations: configuration.destination,
                    product: .app,
                    bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())Demo",
                    deploymentTargets: configuration.deploymentTarget,
                    infoPlist: .extendingDefault(with: configuration.infoPlist),
                    sources: ["Demo/Sources/**"],
                    resources: [.glob(pattern: "Demo/Resources/**", excluding: [])],
                    dependencies: [
                        .target(name: moduleTargetName)
                    ]
                )
                targets.append(demoTarget)
                schemes.append(
                    Scheme.configureDemoAppScheme(schemeName: demoTargetName)
                )
            }
            
            let moduleScheme = Scheme.configureScheme(
                schemeName: moduleTargetName,
                configurationName: configuration.name,
                targetName: moduleTargetName,
                codeCoverageTargets: [name]
            )
            
            schemes.append(moduleScheme)
            
            return Project(
                name: name,
                organizationName: configuration.organizationName,
                settings: configuration.commonSettings,
                targets: targets,
                schemes: schemes
            )
        case let .domain(name):
            // Doamin
            let domainName = name == "Domain" ? "Domain" : "\(name)Domain"
            let moduleTarget = Target.target(
                name: domainName,
                destinations: configuration.destination,
                product: product,
                bundleId: "\(configuration.bundleIdentifier).\(domainName.lowercased())",
                deploymentTargets: configuration.deploymentTarget,
                sources: ["Sources/**"],
                resources: hasResources ? ["Resources/**"] : [],
                dependencies: dependencies
            )
            targets.append(moduleTarget)
            
            // Tests
            let testTargetName = "\(domainName)Tests"
            let testTarget = Target.target(
                name: testTargetName,
                destinations: configuration.destination,
                product: .unitTests,
                bundleId: "\(configuration.bundleIdentifier).\(domainName.lowercased()).test",
                deploymentTargets: configuration.deploymentTarget,
                sources: ["Tests/Sources/**"],
                dependencies: [.target(name: domainName)]
            )
            targets.append(testTarget)
            
            let moduleScheme = Scheme.configureScheme(
                schemeName: domainName,
                configurationName: configuration.name,
                targetName: domainName,
                testTargetName: testTargetName,
                codeCoverageTargets: [domainName]
            )
            
            schemes.append(moduleScheme)
            
            return Project(
                name: domainName,
                organizationName: configuration.organizationName,
                settings: configuration.commonSettings,
                targets: targets,
                schemes: schemes
            )
        }
    }
    
    // MARK: MicroFeature 생성
    private static func configureMicroFeatureProject(
        configuration: AppConfiguration,
        product: Product,
        name: String,
        organizationName: String,
        targets: [Target],
        dependencies: [TargetDependency],
        interfaceDependencies: [TargetDependency]
    ) -> Project {
        
        // Interface 타겟
        let interfaceTargetName = "\(name)Interface"
        let interfaceTarget = Target.target(
            name: interfaceTargetName,
            destinations: configuration.destination,
            product: product,
            bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())Interface",
            deploymentTargets: configuration.deploymentTarget,
            infoPlist: .default,
            sources: ["Interface/Sources/**"],
            dependencies: dependencies
        )
        
        // Framework 타겟
        let frameworkTargetName = name
        let frameworkDependencies = interfaceDependencies + [.target(name: interfaceTargetName)]
        
        let frameworkTarget = Target.target(
            name: frameworkTargetName,
            destinations: configuration.destination,
            product: product,
            bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())",
            deploymentTargets: configuration.deploymentTarget,
            infoPlist: .default,
            sources: ["Sources/**"],
            dependencies: frameworkDependencies
        )
        
        // Demo 타겟
        let demoTargetName = "\(name)Demo"
        let demoTarget = Target.target(
            name: demoTargetName,
            destinations: configuration.destination,
            product: .app,
            bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())Demo",
            deploymentTargets: configuration.deploymentTarget,
            infoPlist: .extendingDefault(with: configuration.infoPlist),
            sources: ["Demo/Sources/**"],
            resources: [.glob(pattern: "Demo/Resources/**", excluding: [])],
            dependencies: [
                .target(name: frameworkTargetName)
            ]
        )
        
        // Test 타겟
        let testTargetName = "\(name)Test"
        let testTarget = Target.target(
            name: testTargetName,
            destinations: configuration.destination,
            product: product,
            bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())Test",
            deploymentTargets: configuration.deploymentTarget,
            infoPlist: .default,
            sources: ["Test/Sources/**"],
            dependencies: [
                .target(name: interfaceTargetName)
            ]
        )
        
        // Tests 타겟
        let testsTargetName = "\(name)Tests"
        let testsTarget = Target.target(
            name: testsTargetName,
            destinations: configuration.destination,
            product: .unitTests,
            bundleId: "\(configuration.bundleIdentifier).\(name.lowercased())Tests",
            deploymentTargets: configuration.deploymentTarget,
            infoPlist: .default,
            sources: ["Tests/Sources/**"],
            dependencies: [
                .target(name: frameworkTargetName),
                .target(name: testTargetName)
            ]
        )
        
        let targets = [interfaceTarget, frameworkTarget, demoTarget, testsTarget, testTarget]
        
        let frameworkScheme = Scheme.configureScheme(
            schemeName: frameworkTargetName,
            configurationName: configuration.name,
            targetName: frameworkTargetName,
            testTargetName: testsTargetName,
            codeCoverageTargets: [frameworkTargetName]
        )
        
        let demoScheme = Scheme.configureDemoAppScheme(schemeName: "\(name)Demo")
        
        // 프로젝트 생성
        return Project(
            name: name,
            organizationName: organizationName,
            settings: configuration.commonSettings,
            targets: targets,
            schemes: [frameworkScheme, demoScheme]
        )
    }
}

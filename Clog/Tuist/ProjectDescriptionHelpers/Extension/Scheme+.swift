//
//  AppScheme.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import ProjectDescription

extension Scheme {
    static func configureAppScheme(
        schemeName: String
    ) -> [Scheme] {
        let developConfiguration: ConfigurationName = .configuration("Dev")
        let testConfiguration: ConfigurationName = .configuration("Test")
        let productionConfiguration: ConfigurationName = .configuration("Prod")
        
        let buildAction = BuildAction.buildAction(targets: [TargetReference(stringLiteral: schemeName)])
        
        return [
            Scheme.scheme(
                name: schemeName + "-Dev",
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: developConfiguration),
                archiveAction: .archiveAction(configuration: developConfiguration),
                profileAction: .profileAction(configuration: developConfiguration),
                analyzeAction: .analyzeAction(configuration: developConfiguration)
            ),
            Scheme.scheme(
                name: schemeName + "-Test",
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: testConfiguration),
                archiveAction: .archiveAction(configuration: testConfiguration),
                profileAction: .profileAction(configuration: testConfiguration),
                analyzeAction: .analyzeAction(configuration: testConfiguration)
            ),
            Scheme.scheme(
                name: schemeName + "-Prod",
                shared: true,
                buildAction: buildAction,
                runAction: .runAction(configuration: productionConfiguration),
                archiveAction: .archiveAction(configuration: productionConfiguration),
                profileAction: .profileAction(configuration: productionConfiguration),
                analyzeAction: .analyzeAction(configuration: productionConfiguration)
            )
        ]
    }
    
    static func configureDemoAppScheme(
        schemeName: String
    ) -> Scheme {
        let developConfiguration: ConfigurationName = .configuration("Dev")
        
        let buildAction = BuildAction.buildAction(targets: [TargetReference(stringLiteral: schemeName)])
        
        return Scheme.scheme(
            name: schemeName,
            shared: true,
            buildAction: buildAction,
            runAction: .runAction(configuration: developConfiguration),
            archiveAction: .archiveAction(configuration: developConfiguration),
            profileAction: .profileAction(configuration: developConfiguration),
            analyzeAction: .analyzeAction(configuration: developConfiguration)
        )
    }
    
    static func configureScheme(
        schemeName: String,
        configurationName: ConfigurationName,
        targetName: String,
        testTargetName: String? = nil,
        codeCoverageTargets: [String] = []
    ) -> Scheme {
        let argument = Arguments.arguments()
        
        // TestAction 생성
        let buildAction = BuildAction.buildAction(targets: [TargetReference(stringLiteral: schemeName)])
        
        // TestAction 생성
        let testAction: TestAction? = testTargetName.map { testTarget in
            TestAction.targets(
                [TestableTarget(stringLiteral: testTarget)],
                arguments: argument,
                configuration: configurationName,
                options: .options(
                    coverage: true,
                    codeCoverageTargets: codeCoverageTargets.map { TargetReference(stringLiteral: $0) }
                )
            )
        }
        
        // RunAction 생성
        let runAction = RunAction.runAction(
            configuration: configurationName,
            executable: TargetReference(stringLiteral: targetName),
            arguments: argument
        )
        
        // ArchiveAction 생성
        let archiveAction = ArchiveAction.archiveAction(configuration: configurationName)
        
        // ProfileAction 생성
        let profileAction = ProfileAction.profileAction(configuration: configurationName)
        
        // AnalyzeAction 생성
        let analyzeAction = AnalyzeAction.analyzeAction(configuration: configurationName)
        
        return Scheme.scheme(
                name: schemeName,
                shared: true,
                buildAction: buildAction,
                testAction: testAction,
                runAction: runAction,
                archiveAction: archiveAction,
                profileAction: profileAction,
                analyzeAction: analyzeAction
        )
    }
}

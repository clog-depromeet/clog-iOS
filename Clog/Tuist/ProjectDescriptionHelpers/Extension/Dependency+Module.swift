//
//  Dependency+Project.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung Lee on 1/9/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Modules {}
}

public extension TargetDependency.Modules {
    
    static func shared(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Shared",
            path: .relativeToModule(path: "Shared", service: service)
        )
    }
    
    static func thirdPartyLibrary(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "ThirdPartyLibrary",
            path: .relativeToModule(path: "ThirdPartyLibrary", service: service)
        )
    }
    
    static let umbrella = TargetDependency.project(
        target: "Umbrella",
        path: .relativeUmbrella()
    )
}

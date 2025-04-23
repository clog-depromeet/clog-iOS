//
//  Dependency+Data.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 1/27/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Data {}
}

public extension TargetDependency.Data {
    static func data(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Data",
            path: .releativeData(service)
        )
    }
    
    static func networker(_ service: ServiceType) -> TargetDependency {
        TargetDependency.project(
            target: "Networker",
            path: .releativeNetworker(service)
        )
    }
}

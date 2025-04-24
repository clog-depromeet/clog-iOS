//
//  Dependency+Service.swift
//  Config
//
//  Created by Junyoung on 1/24/25.
//

import ProjectDescription

public enum ServiceType: String {
    case clog = "ClogService"
}

public extension TargetDependency {
    struct Services {
        public struct Clog {}
    }
}

public extension TargetDependency.Services {
    static func project(name: String) -> TargetDependency {
        return .project(target: name, path: .relativeToRoot("Projects/\(name)/Service"))
    }
}

public extension TargetDependency.Services.Clog {
    static let name = "Clog"
    static let service = TargetDependency.Services.project(name: "\(name)Service")
}

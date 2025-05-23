//
//  Dependency+Domain.swift
//  Config
//
//  Created by Junyoung Lee on 1/21/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Domains {
        public struct Social {}
        public struct Token {}
        public struct Edit {}
        public struct Report {}
        public struct Story {}
        public struct Folder {}
        public struct Calendar {}
        public struct Video {}
        public struct Account {}
        public struct Domain {}
    }
}

public extension TargetDependency.Domains {
    static func project(name: String, service: ServiceType) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToDomain(path: name, service: service)
        )
    }
}

public extension TargetDependency.Domains.Domain {
    static let name = "Domain"
    
    static func domain(_ service: ServiceType) -> TargetDependency {
        TargetDependency.Domains.project(
            name: "\(name)",
            service: service
        )
    }
}

public extension TargetDependency.Domains.Account {
    static let name = "Account"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Video {
    static let name = "Video"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Folder {
    static let name = "Folder"
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}
    
public extension TargetDependency.Domains.Calendar {
    static let name = "Calendar"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Story {
    static let name = "Story"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Report {
    static let name = "Report"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Edit {
    static let name = "Edit"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Token {
    static let name = "Token"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

public extension TargetDependency.Domains.Social {
    static let name = "Social"
    
    static let domain = TargetDependency.Domains.project(
        name: "\(name)Domain",
        service: .clog
    )
}

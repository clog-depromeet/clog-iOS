//
//  Dependency+Feature.swift
//  Config
//
//  Created by Junyoung Lee on 1/21/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Features {
        public struct AddAttempts {}
        public struct Social {}
        public struct ProfileEditor {}
        public struct CompletionReport {}
        public struct NickName {}
        public struct Onboarding {}
        public struct Splash {}
        public struct Report {}
        public struct Setting {}
        public struct Edit {}
        public struct Calendar {}
        public struct Folder {}
        public struct FolderTab {}
        public struct Video {}
        public struct Login {}
        public struct Root {}
        public struct Main {}
    }
}

public extension TargetDependency.Features {
    static func project(name: String, service: ServiceType) -> TargetDependency {
        return .project(
            target: name,
            path: .relativeToFeature(path: name, service: service)
        )
    }
}

public extension TargetDependency.Features.Root {
    static let name = "Root"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Main {
    static let name = "Main"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Login {
    static let name = "Login"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Video {
    static let name = "Video"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.FolderTab {
    static let name = "FolderTab"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Folder {
    static let name = "Folder"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Calendar {
    static let name = "Calendar"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Edit {
    static let name = "Edit"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Setting {
    static let name = "Setting"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Report {
    static let name = "Report"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Splash {
    static let name = "Splash"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Onboarding {
    static let name = "Onboarding"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.NickName {
    static let name = "NickName"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.CompletionReport {
    static let name = "CompletionReport"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.Social {
    static let name = "Social"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.ProfileEditor {
    static let name = "ProfileEditor"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

public extension TargetDependency.Features.AddAttempts {
    static let name = "AddAttempts"
    
    static let feature = TargetDependency.Features.project(
        name: "\(name)Feature",
        service: .clog
    )
    
    static let interface = TargetDependency.project(
        target: "\(name)FeatureInterface",
        path: .relativeToFeature(path: "\(name)Feature", service: .clog)
    )
}

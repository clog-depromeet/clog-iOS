//
//  SettingDictionary+.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung Lee on 1/9/25.
//

import ProjectDescription

public extension SettingsDictionary {
    static let baseSettings: Self = SettingsDictionary().otherLinkerFlags([
        "$(inherited)", "-ObjC"
    ])
    
    // 디버그 설정 추가
    static let debugSettings: Self = baseSettings
        .swiftOptimizationLevel(.oNone)
        .merging([
            "COPY_PHASE_STRIP": "NO",
            "STRIP_INSTALLED_PRODUCT": "NO",
            "ONLY_ACTIVE_ARCH": "YES"
        ]) { _, new in new }
    
    func configureAutoCodeSigning() -> SettingsDictionary {
        return automaticCodeSigning(devTeam: "SUMATJC294")
    }
    
    func configureVersioning() -> SettingsDictionary {
        currentProjectVersion("1")
            .marketingVersion("1.0.4")
            .appleGenericVersioningSystem()
    }
    
    func configureTestability() -> SettingsDictionary {
        merging(["ENABLE_TESTABILITY": "YES"])
    }
}

//
//  AppVersionCheckProtocol.swift
//  SplashFeatureInterface
//
//  Created by Junyoung on 4/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public protocol AppVersionCheckProtocol {
    func isAppVersionLowerThanMinimum() async -> Bool
}

enum AppVersionCheckDependencyKey: DependencyKey {
    static let liveValue: AppVersionCheckProtocol = ClogDI.container.resolve(AppVersionCheckProtocol.self)!
}

extension DependencyValues {
    public var appVersionCheck: AppVersionCheckProtocol {
        get { self[AppVersionCheckDependencyKey.self] }
        set { self[AppVersionCheckDependencyKey.self] = newValue }
    }
}

//
//  SplashDataManager.swift
//  SplashFeature
//
//  Created by Junyoung on 3/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

enum SplashDataKey {
    static let onboardingCompleted = "hasCompletedOnboarding"
}

struct SplashDataManager {
    static var hasCompleted: Bool {
        get {
            UserDefaults.standard.bool(forKey: SplashDataKey.onboardingCompleted)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: SplashDataKey.onboardingCompleted)
        }
    }
}

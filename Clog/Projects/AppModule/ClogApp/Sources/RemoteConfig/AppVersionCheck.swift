//
//  AppVersionCheck.swift
//  ClogService
//
//  Created by Junyoung on 4/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import SplashFeatureInterface

import Swinject
import FirebaseRemoteConfig

struct AppVersionCheck: AppVersionCheckProtocol {
    let remoteConfig = RemoteConfig.remoteConfig()
    let settings = RemoteConfigSettings()
    
    func isAppVersionLowerThanMinimum() async -> Bool {
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
        
        do {
            let _ = try await remoteConfig.fetch()
            let _ = try await remoteConfig.activate()
            
            let minVersion = remoteConfig["ios_min_version"].stringValue
            
            guard let currentVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String else {
                return true
            }
            
            return currentVersion < minVersion
            
        } catch {
            print("Remote Config error: \(error.localizedDescription)")
            return true
        }
    }
}

public struct AppVersionCheckAssembly: Assembly {
    
    public init() {}
    
    public func assemble(container: Container) {
        container.register(AppVersionCheckProtocol.self) { _ in
            return AppVersionCheck()
        }
    }
}

//
//  AppConfiguration.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

import Foundation
import ProjectDescription

public struct AppConfiguration {
    
    public init() {}
    
    let workspaceName = "Clog"
    let projectName: String = "Clog"
    let organizationName = "Supershy"
    let shortVersion: String = "1.0.6"
    let bundleIdentifier: String = "$(PRODUCT_BUNDLE_IDENTIFIER)"
    let displayName: String = "클로그"
    let destination: Set<Destination> = [.iPhone]
    var entitlements: Entitlements? = "ClogProduction.entitlements"
    let deploymentTarget: DeploymentTargets = .iOS("17.0")
    let kakaoNativeAppKey: String = "$(KAKAO_NATIVE_APP_KEY)"
    let baseURL: String = "$(BASE_URL)"

    
    public var name: ConfigurationName {
        return ConfigurationName(stringLiteral: "Dev")
    }
    public var prodName: ConfigurationName {
        return ConfigurationName(stringLiteral: "Prod")
    }
    
    var infoPlist: [String : Plist.Value] {
        InfoPlist.appInfoPlist(self)
    }
    
    public var autoCodeSigning: SettingsDictionary {
        return SettingsDictionary().automaticCodeSigning(devTeam: "SUMATJC294")
    }
    
    var setting: Settings {
        return Settings.settings(
            base: [:],
            configurations: XCConfig.project
        )
    }
    
    let commonSettings = Settings.settings(
        base: SettingsDictionary.debugSettings
            .configureAutoCodeSigning()
            .configureVersioning()
            .configureTestability(),
        configurations: XCConfig.framework
    )
}

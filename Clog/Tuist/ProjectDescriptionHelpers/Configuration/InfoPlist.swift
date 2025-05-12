//
//  InfoPlist.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

@preconcurrency import ProjectDescription

public struct InfoPlist {
    private static let commonInfoPlist: [String: Plist.Value] = [
        "CFBundleDevelopmentRegion": "ko",
        "CFBundleVersion": "1",
        "UILaunchScreen": [
            "BackgroundColor": "systemBackgroundColor"
        ],
        "UIUserInterfaceStyle": "Light",
        "LSSupportsOpeningDocumentsInPlace": true,
        "ITSAppUsesNonExemptEncryption": false,
        "UIApplicationSceneManifest": [
            "UIApplicationSupportsMultipleScenes": false,
            "UISceneConfigurations": [
                "UIWindowSceneSessionRoleApplication": [
                    [
                        "UISceneConfigurationName": "Default Configuration",
                        "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                    ],
                ]
            ]
        ],
        "LSApplicationQueriesSchemes" : [
            "kakaokompassauth",
        ],
        "CFBundleURLTypes": [
            [
                "CFBundleTypeRole": "Editor",
                "CFBundleURLSchemes": [
                    "kakao$(KAKAO_NATIVE_APP_KEY)",
                ]
            ]
        ],
        "NSCameraUsageDescription": "이 앱은 프로필 사진 촬영을 위해 카메라 접근 권한이 필요합니다.",
        "NSMicrophoneUsageDescription": "이 앱은 음성 녹음 기능을 사용하기 위해 마이크 접근 권한이 필요합니다.",
        "NSPhotoLibraryUsageDescription": "촬영한 사진과 동영상을 저장하기 위해 사진 접근 권한이 필요합니다.",
        "NSPhotoLibraryAddUsageDescription": "촬영한 동영상을 사진첩에 저장하려면 권한이 필요합니다.",
        "NSUserTrackingUsageDescription": "클로그 앱에서 사용자에게 맞춤 서비스를 제공하기 위해 추적 권한을 요청합니다",
        "NSLocationWhenInUseUsageDescription": "근처 암장 정보 검색을 위해 위치 정보 권한이 필요합니다.",
    ]
    
    static func appInfoPlist(_ appConfiguration: AppConfiguration) -> [String: Plist.Value] {
        var infoPlist = commonInfoPlist
        infoPlist["CFBundleShortVersionString"] = .string(appConfiguration.shortVersion)
        infoPlist["CFBundleIdentifier"] = .string(appConfiguration.bundleIdentifier)
        infoPlist["CFBundleDisplayName"] = .string(appConfiguration.displayName)
        infoPlist["KakaoNativeAppKey"] = .string(appConfiguration.kakaoNativeAppKey)
        infoPlist["baseURL"] = .string(appConfiguration.baseURL)
        return infoPlist
    }
    
    static var permissionPlist: [String: Plist.Value] {
        return [
            "NSCameraUsageDescription": "이 앱은 프로필 사진 촬영을 위해 카메라 접근 권한이 필요합니다.",
            "NSMicrophoneUsageDescription": "이 앱은 음성 녹음 기능을 사용하기 위해 마이크 접근 권한이 필요합니다.",
            "NSPhotoLibraryUsageDescription": "촬영한 사진과 동영상을 저장하기 위해 사진 접근 권한이 필요합니다.",
            "NSPhotoLibraryAddUsageDescription": "촬영한 동영상을 사진첩에 저장하려면 권한이 필요합니다."
        ]
    }
}

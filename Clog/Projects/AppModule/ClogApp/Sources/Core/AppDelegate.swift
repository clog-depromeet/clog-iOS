//
//  SampleApp.swift
//  SampleApp
//
//  Created by Junyoung on 1/8/25.
//

import UIKit

import Firebase
import DesignKit
import KakaoSDKCommon
import Photos
import CoreLocation
import AppTrackingTransparency
 
class AppDelegate: UIResponder, UIApplicationDelegate {
    private var locationManager: CLLocationManager?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        Analytics.setAnalyticsCollectionEnabled(true)
        
        if let kakaoNativeAppKey = Bundle.main.object(forInfoDictionaryKey: "KakaoNativeAppKey") as? String {
            KakaoSDK.initSDK(appKey: kakaoNativeAppKey)
        }
        
        Task {
            try? await Task.sleep(nanoseconds: 500_000_000)
            await requestTrackingAuthorization()
            await checkMicrophonePermission()
            await requestVideoPermission()
            await requestPhotoLibraryPermission()
            requestLocationPermission()
        }
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(
            name: "Default Configuration",
            sessionRole: connectingSceneSession.role
        )
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}

    func application(
        _ application: UIApplication,
        supportedInterfaceOrientationsFor window: UIWindow?
    ) -> UIInterfaceOrientationMask {
        return .portrait
    }
}

extension AppDelegate {
    private func requestPhotoLibraryPermission() async {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            print("✅ 사진첩 권한 허용됨")
        case .restricted, .denied, .notDetermined:
            print("❌ 권한 없음 또는 취소됨")
        @unknown default:
            break
        }
    }
    
    private func requestVideoPermission() async {
        let status = await AVCaptureDevice.requestAccess(for: .video)
        
        if status {
            print("✅ AVCapture 허용")
        } else {
            print("❌ AVCapture 권한 없음")
        }
    }
    
    private func checkMicrophonePermission() async {
        let status = await AVAudioApplication.requestRecordPermission()
        
        if status {
            print("✅ AVAudioApplication 허용")
        } else {
            print("❌ AVAudioApplication 권한 없음")
        }
    }
    
    private func requestTrackingAuthorization() async {
        let status = await ATTrackingManager.requestTrackingAuthorization()
        
        switch status {
        case .authorized:           // 허용됨
            print("Authorized")
        case .denied:               // 거부됨
            print("Denied")
        case .notDetermined:        // 결정되지 않음
            print("Not Determined")
        case .restricted:           // 제한됨
            print("Restricted")
        @unknown default:           // 알려지지 않음
            print("unknow")
        }
    }
    
    private func requestLocationPermission() {
        locationManager = CLLocationManager()
        locationManager?.requestWhenInUseAuthorization()
    }
}

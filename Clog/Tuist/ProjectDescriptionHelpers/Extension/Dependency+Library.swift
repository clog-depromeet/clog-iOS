//
//  Dependency+Library.swift
//  ProjectDescriptionHelpers
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription

public extension TargetDependency {
    struct Framework {}
    struct Library {}
    struct SPM {}
}

public extension TargetDependency.Framework {}

public extension TargetDependency.Library {
    static let tca = TargetDependency.external(name: "ComposableArchitecture")
    static let moya = TargetDependency.external(name: "Moya")
    static let then = TargetDependency.external(name: "Then")
    static let swinject = TargetDependency.external(name: "Swinject")
    static let KakaoSDKUser = TargetDependency.external(name: "KakaoSDKUser")
    
    // 네트워크
    static let pulse = TargetDependency.external(name: "Pulse")
    static let pulseUI = TargetDependency.external(name: "PulseUI")
    static let pulseProxy = TargetDependency.external(name: "PulseProxy")
}

public extension TargetDependency.SPM {
    static let firebaseCore = TargetDependency.package(product: "FirebaseCore")
    static let firebaseAuth = TargetDependency.package(product: "FirebaseAuth")
    static let firebaseAnalytics = TargetDependency.package(product: "FirebaseAnalytics")
    static let firebaseRemoteConfig = TargetDependency.package(product: "FirebaseRemoteConfig")
    static let firebaseMessaging = TargetDependency.package(product: "FirebaseMessaging")
    static let firebasePerformance = TargetDependency.package(product: "FirebasePerformance")
    static let firebaseCrashlytics = TargetDependency.package(product: "FirebaseCrashlytics")
}

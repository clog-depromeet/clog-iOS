//
//  Project.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .app,
    product: .app,
    dependencies: [
        .Modules.umbrella,
        
        .SPM.firebaseCore,
        .SPM.firebaseAuth,
        .SPM.firebaseAnalytics,
        .SPM.firebaseMessaging,
        .SPM.firebaseCrashlytics,
        .SPM.firebasePerformance,
        .SPM.firebaseRemoteConfig,
        
    ],
    packages: [
        .remote(url: "https://github.com/firebase/firebase-ios-sdk.git", requirement: .exact("11.8.1"))
    ]
)

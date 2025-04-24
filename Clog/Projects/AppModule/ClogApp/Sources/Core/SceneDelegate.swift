//
//  SceneDeleagte.swift
//  Clog
//
//  Created by saeng lin on 2/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI
import KakaoSDKAuth
import ClogService

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let view = RouterView(store: RouterFeature.initialStore)
        
        window = ClogWindow(windowScene: windowScene)
        window?.backgroundColor = .clear
        window?.rootViewController = UIHostingController(rootView: view)
        window?.makeKeyAndVisible()
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    func sceneDidBecomeActive(_ scene: UIScene) {}
    func sceneWillResignActive(_ scene: UIScene) {}
    func sceneWillEnterForeground(_ scene: UIScene) {}
    func sceneDidEnterBackground(_ scene: UIScene) {}
    
    func scene(
        _ scene: UIScene,
        openURLContexts URLContexts: Set<UIOpenURLContext>
    ) {
        if let url = URLContexts.first?.url,
           AuthApi.isKakaoTalkLoginUrl(url) {
            _ = AuthController.handleOpenUrl(url: url)
        }
    }
}

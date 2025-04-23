//
//  ClogApp.swift
//  Clog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit

import DesignKit

import MainFeature
import LoginFeature
import ClogService
import VideoFeature
import Shared

@main
class ClogApp {
    
    static func main() {
        
        // Phase 세팅
        ClogPhase.main()
        
        // DI 세팅
        ClogDI.register(assemblies: [
            Clogger(),
            ClogFont(),
            
            //
            ClogServiceAssembly(),
            
            // Feature
            HomeFeatureAssembly(),
            MainFeatureAssembly(),
            VideoFeatureAssembly(),
            
            AppVersionCheckAssembly()
        ])
        
        // App Start
        AppDelegate.main()
    }
}

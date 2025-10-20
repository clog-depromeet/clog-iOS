//
//  EditFeatureTooltipManager.swift
//  EditFeature
//
//  Created by seunghwan Lee on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

final class EditFeatureTooltipManager {
    private enum UserDefaultsTooltipKeys: String {
        case isInitializedTooltipState
        case isStampTooltipOn
        case isDragEditTooltipOn
    }
    
    private var isInitializedTooltipState: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsTooltipKeys.isInitializedTooltipState.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsTooltipKeys.isInitializedTooltipState.rawValue)
        }
    }
    
    var isStampTooltipOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsTooltipKeys.isStampTooltipOn.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsTooltipKeys.isStampTooltipOn.rawValue)
        }
    }
    
    var isDragEditTooltipOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: UserDefaultsTooltipKeys.isDragEditTooltipOn.rawValue)
        } set {
            UserDefaults.standard.set(newValue, forKey: UserDefaultsTooltipKeys.isDragEditTooltipOn.rawValue)
        }
    }
    
    func initTooltipState() {
        if isInitializedTooltipState == false {
            isStampTooltipOn = true
            isDragEditTooltipOn = false
            isInitializedTooltipState = true
        }
    }
    
    func setStampTooltipOff() {
        isStampTooltipOn = false
        isDragEditTooltipOn = true
    }
    
    func setDragEditTooltipOff() {
        isDragEditTooltipOn = false
    }
}

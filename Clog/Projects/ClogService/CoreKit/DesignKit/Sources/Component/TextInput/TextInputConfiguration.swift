//
//  TextConfiguration.swift
//  DesignKit
//
//  Created by Junyoung on 3/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI

public struct TextInputConfiguration {
    var state: TextInputState
    var type: TextInputType
    var background: TextInputBackground
}

public enum TextInputType {
    case filed
    case editor
}

public enum TextInputBackground {
    case gray700
    case gray800
    case gray900
    
    var color: Color {
        switch self {
        case .gray700:
            return Color.clogUI.gray700
        case .gray800:
            return Color.clogUI.gray800
        case .gray900:
            return Color.clogUI.gray900
        }
    }
}

public enum TextInputState {
    case normal
    case disable
    case error
    
    var foregroundColor: Color {
        switch self {
        case .normal:
            return .clogUI.gray50
        case .disable:
            return .clogUI.gray600
        case .error:
            return .clogUI.fail
        }
    }
}

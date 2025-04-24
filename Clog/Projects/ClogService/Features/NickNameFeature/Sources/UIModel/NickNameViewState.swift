//
//  NickNameViewState.swift
//  NickNameFeature
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public enum NickNameViewState {
    case create
    case update
    
    var buttonTitle: String {
        switch self {
        case .create:
            "다음"
        case .update:
            "저장하기"
        }
    }
}

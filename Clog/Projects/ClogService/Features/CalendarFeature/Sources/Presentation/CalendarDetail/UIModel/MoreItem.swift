//
//  MoreItem.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI
import DesignKit

public enum MoreItem: Equatable, CaseIterable {
    case edit
    case delete
    
    var title: String {
        switch self {
        case .edit:
            return "메모 수정"
        case .delete:
            return "기록 삭제"
        }
    }
    
    var color: Color {
        switch self {
        case .edit:
            return Color.clogUI.gray10
        case .delete:
            return Color.clogUI.fail
        }
    }
    
    var image: Image {
        switch self {
        case .edit:
            return Image.clogUI.edit
        case .delete:
            return Image.clogUI.delete
        }
    }
}

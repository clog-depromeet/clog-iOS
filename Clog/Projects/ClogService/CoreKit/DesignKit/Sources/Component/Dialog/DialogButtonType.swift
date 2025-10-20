//
//  DialogButtonType.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct DialogButtonType: Equatable, Hashable {
    var id: UUID = UUID()
    let title: String
    let style: DialogStyle
    let action: () -> Void
    
    static func == (
        lhs: DialogButtonType,
        rhs: DialogButtonType
    ) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(style)
    }
}

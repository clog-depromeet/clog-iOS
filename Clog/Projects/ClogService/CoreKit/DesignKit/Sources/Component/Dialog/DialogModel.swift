//
//  DialogModel.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

struct DialogModel: Equatable, Identifiable {
    var id: UUID = UUID()
    let title: String
    let message: String
    let buttons: [DialogButtonType]
}

//
//  Toast.swift
//  DesignKit
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Toast: Equatable {
    var message: String
    var type: ToastType
    var duration: Double = 2
    var width: Double = .infinity
    
    public init(
        message: String,
        type: ToastType
    ) {
        self.message = message
        self.type = type
    }
}

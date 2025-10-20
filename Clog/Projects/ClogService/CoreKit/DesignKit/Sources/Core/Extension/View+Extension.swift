//
//  Image+Extension.swift
//  DesignKit
//
//  Created by 강현준 on 5/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public extension View {
    func frame(_ size: CGFloat) -> some View {
        self.frame(width: size, height: size)
    }
}

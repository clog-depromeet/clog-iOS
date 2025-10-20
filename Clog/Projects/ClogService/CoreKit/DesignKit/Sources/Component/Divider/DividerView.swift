//
//  DividerView.swift
//  DesignKit
//
//  Created by Junyoung on 3/21/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum DividerType {
    case horizontal
    case vertical
}

public struct DividerView: View {
    private let type: DividerType
    private let color: Color
    
    public init(
        _ type: DividerType,
        color: Color = Color.clogUI.gray800
    ) {
        self.type = type
        self.color = color
    }
    
    public var body: some View {
        ZStack(alignment: .center) {
            Rectangle()
                .fill(color)
                .frame(
                    width: type == .vertical ? 1 : nil,
                    height: type == .horizontal ? 1 : nil
                )
        }
        .frame(
            width: type == .vertical ? 35.5 : nil,
            height: type == .horizontal ? 17 : nil
        )
    }
}

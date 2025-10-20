//
//  LevelChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct LevelChip: View {
    let name: String
    let color: Color
    let backgroundColor: Color
    
    public init(
        name: String,
        color: Color,
        backgroundColor: Color = .clogUI.gray700
    ) {
        self.name = name
        self.color = color
        self.backgroundColor = backgroundColor
    }
    
    public var body: some View {
        HStack(spacing: 5) {
            Circle()
                .fill(color)
                .frame(width: 10, height: 10)
            
            Text(name)
                .font(.h5)
                .foregroundStyle(Color.clogUI.gray200)
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(backgroundColor)
        )
    }
}

#Preview {
    LevelChip(name: "하양", color: .white)
}

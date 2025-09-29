//
//  FloatingActionButton.swift
//  DesignKit
//
//  Created by soi on 6/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct FloatingActionButton: View {
    private let image: Image
    private let action: () -> Void
    
    public init(
        image: Image,
        action: @escaping () -> Void
    ) {
        self.image = image
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.clogUI.primary)
                    .frame(width: 58, height: 58)
                
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.gray800)
            }
            .padding(.trailing, 16)
            .padding(.bottom, 18)
        }
    }
}

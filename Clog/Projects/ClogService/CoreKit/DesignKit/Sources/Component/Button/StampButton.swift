//
//  StampButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum StampType {
    case `default`
    case lined
}

public struct StampButton: View {
    private let type: StampType
    private var onTapped: () -> Void
    
    public init(
        type: StampType = .default,
        onTapped: @escaping () -> Void
    ) {
        self.type = type
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            Image.clogUI.stamp
                .resizable()
                .frame(
                    width: 40,
                    height: 40
                )
                .foregroundStyle(Color.clogUI.primary)
                .padding(10)
                .background(Color.clogUI.green800)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .overlay(
                    Group {
                        if case .lined = type {
                            RoundedRectangle(cornerRadius: 20)
                                .strokeBorder(
                                    Color.clogUI.primary,
                                    lineWidth: 3
                                )
                        }
                    }
                )
        }
    }
}

#Preview {
    HStack {
        GroupBox(label: Text("Default Stamp")) {
            StampButton() {
                
            }
        }
        
        GroupBox(label: Text("Lined Stamp")) {
            StampButton(type: .lined) {
                
            }
        }
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clogUI.gray700)
}

//
//  NextProblemButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct NextProblemButton: View {
    private let onTapped: () -> Void
    
    public init(
        onTapped: @escaping () -> Void
    ) {
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            Text("다음\n문제")
                .font(.c1)
                .foregroundStyle(Color.clogUI.gray10)
                .padding(.vertical, 12)
                .padding(.horizontal, 19.5)
                .background(
                    Circle()
                        .fill(Color.clogUI.gray600)
                        .frame(width: 60, height: 60)
                )
        }
    }
}

#Preview {
    NextProblemButton() {
        
    }
}

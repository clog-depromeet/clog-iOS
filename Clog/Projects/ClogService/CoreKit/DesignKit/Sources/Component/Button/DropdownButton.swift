//
//  DropdownButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct DropdownButton: View {
    @Binding private var isOpen: Bool
    private let onTapped: () -> Void
    
    public init(
        isOpen: Binding<Bool>,
        onTapped: @escaping () -> Void
    ) {
        self._isOpen = isOpen
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.gray700)
                
                Image.clogUI.down
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clogUI.gray50)
                    .rotationEffect(.degrees(isOpen ? 180 : 0))
            }
        }
    }
}

struct ContainerDropdownButton: View {
    @State var isOpen: Bool
    var body: some View {
        DropdownButton(isOpen: $isOpen) {
            isOpen.toggle()
        }
    }
}

#Preview {
    ContainerDropdownButton(isOpen: false)
}

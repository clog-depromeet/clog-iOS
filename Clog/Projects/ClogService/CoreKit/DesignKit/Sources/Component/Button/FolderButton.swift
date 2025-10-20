//
//  FolderButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct FolderButton: View {
    @Binding private var count: Int
    private let onTapped: () -> Void
    
    public init(
        count: Binding<Int>,
        onTapped: @escaping () -> Void
    ) {
        self._count = count
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            ZStack(alignment: .topTrailing) {
                Image.clogUI.list
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(Color.clogUI.white)
                    .padding(16)
                    .frame(width: 60, height: 60)
                    .background(Color.clogUI.gray600)
                    .clipShape(RoundedRectangle(cornerRadius: 99))
                    .padding(.top, 4)
                    .padding(.trailing, 4)
                
                if count > 0 {
                    Text("\(count)")
                        .font(.c1)
                        .foregroundStyle(Color.clogUI.gray900)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color.clogUI.primary)
                        .clipShape(Circle())
                }
                
            }
            .frame(width: 64, height: 64)
        }

    }
}

// MARK: - Preview
struct ContainerFolderButton: View {
    @State var count: Int
    
    var body: some View {
        FolderButton(count: $count) {
            count += 1
        }
    }
}

#Preview {
    ZStack {
        ContainerFolderButton(count: 0)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clogUI.gray700)
}

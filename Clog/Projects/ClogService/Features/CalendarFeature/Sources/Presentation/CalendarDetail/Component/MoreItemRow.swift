//
//  MoreItemRow.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/22/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

struct MoreItemRow: View {
    private let item: MoreItem
    private let onTapped: (MoreItem) -> Void
    
    init(
        item: MoreItem,
        onTapped: @escaping (MoreItem) -> Void
    ) {
        self.item = item
        self.onTapped = onTapped
    }
    
    var body: some View {
        Button {
            onTapped(item)
        } label: {
            HStack(spacing: 10) {
                item.image
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(item.color)
                
                Text(item.title)
                    .font(.h4)
                    .foregroundStyle(item.color)
                
                Spacer()
            }
            .padding(.vertical, 12)
            .padding(.horizontal, 8)
        }

    }
}

#Preview {
    MoreItemRow(item: .delete) { _ in
        
    }
}

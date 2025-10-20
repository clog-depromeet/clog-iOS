//
//  SettingRow.swift
//  SettingFeature
//
//  Created by Junyoung on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

struct SettingRow: View {
    let item: SettingItemType
    let onTapped: (SettingItemType) -> Void
    
    var body: some View {
        Button {
            onTapped(item)
        } label: {
            HStack {
                Text(item.title)
                    .font(.b1)
                    .foregroundStyle(item.textColor)
                
                
                Spacer()
                
                if item.hasArrow {
                    Image.clogUI.right
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(Color.clogUI.gray400)
                }
                
                if let version = item.versionText {
                    Text(version)
                        .font(.b2)
                        .foregroundStyle(Color.clogUI.gray300)
                }
            }
            .padding(.vertical, 10)
            .padding(.horizontal, 16)
        }
    }
    
    @ViewBuilder
    func getServiceItem() -> some View {
        
    }
}

#Preview {
    SettingRow(item: .deleteAccount) { _ in 
        
    }
}

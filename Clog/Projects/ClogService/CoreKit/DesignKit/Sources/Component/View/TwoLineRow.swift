//
//  TwoLineRow.swift
//  DesignKit
//
//  Created by soi on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct TwoLineRow: View {
    
    private let title: String
    private let subtitle: String
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.h4)
                .foregroundStyle(Color.clogUI.gray10)
            
            Text(subtitle)
                .font(.b2)
                .foregroundStyle(Color.clogUI.gray400)
        }
        .padding(8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .cornerRadius(4)
    }
    
    public init(title: String, subtitle: String) {
        self.title = title
        self.subtitle = subtitle
    }
}

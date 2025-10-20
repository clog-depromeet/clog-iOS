//
//  AppBar.swift
//  DesignKit
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct AppBar<LeftContent: View, RightContent: View>: View {
    
    let title: String?
    let leftContent: LeftContent
    let rightContent: RightContent
    
    public init(
        title: String? = nil,
        @ViewBuilder leftContent: () -> LeftContent,
        @ViewBuilder rightContent: () -> RightContent
    ) {
        self.title = title
        self.leftContent = leftContent()
        self.rightContent = rightContent()
    }
    
    public var body: some View {
        HStack(alignment: .center) {
            leftContent
            if let title {
                Spacer()
                Text(title)
                    .font(.b1)
                    .foregroundStyle(Color.clogUI.gray10)
            }
            Spacer()
            rightContent
        }
        .padding(.horizontal, 16)
        .frame(height: 50)
        .background(Color.clogUI.gray800)
    }
}

#Preview {
    AppBar {
        
    } rightContent: {
        
    }

}

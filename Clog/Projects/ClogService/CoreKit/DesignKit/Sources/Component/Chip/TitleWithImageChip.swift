//
//  TitleWithImageChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

/// 타이틀 & 옆에 이미지 들어간 칩 (ex. 난이도, 암장..)
public struct TitleWithImageChip: View {
    private let title: String
    private let imageName: String
    private let forgroundColor: Color
    private let backgroundColor: Color
    private let tapHandler: () -> Void
    
    public init(title: String, imageName: String, forgroundColor: Color, backgroundColor: Color, tapHandler: @escaping () -> Void) {
        self.title = title
        self.imageName = imageName
        self.forgroundColor = forgroundColor
        self.backgroundColor = backgroundColor
        self.tapHandler = tapHandler
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            Text(title)
                .font(.h5)
            Image(imageName, bundle: .module)
                .resizable()
                .frame(width: 21, height: 21)
                
        }
        .padding(EdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 7))
        .foregroundStyle(forgroundColor)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .foregroundStyle(backgroundColor)
        )
        .onTapGesture {
            tapHandler()
        }
    }
}

#Preview {
    Group {
        TitleWithImageChip(
            title: "난이도",
            imageName: "icon_down",
            forgroundColor: Color.clogUI.gray200,
            backgroundColor: Color.clogUI.gray600,
            tapHandler: { print("### 탭") }
        )
        
        TitleWithImageChip(
            title: "암장",
            imageName: "icon_down",
            forgroundColor: Color.clogUI.gray200,
            backgroundColor: Color.clogUI.gray600,
            tapHandler: { print("### 탭") }
        )
        
        TitleWithImageChip(
            title: "초록",
            imageName: "icn_close",
            forgroundColor: Color.clogUI.gray800,
            backgroundColor: Color.clogUI.primary,
            tapHandler: { print("### 탭") }
        )
        
        TitleWithImageChip(
            title: "더클라임",
            imageName: "icn_close",
            forgroundColor: Color.clogUI.gray800,
            backgroundColor: Color.clogUI.primary,
            tapHandler: { print("### 탭") }
        )
    }
}

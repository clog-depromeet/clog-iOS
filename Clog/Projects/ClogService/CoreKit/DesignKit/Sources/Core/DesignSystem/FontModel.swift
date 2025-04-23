//
//  FontModel.swift
//  DesignKit
//
//  Created by Junyoung on 2/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//
import Foundation

public struct FontModel {
    let font: ClogFont.Pretendard
    let size: CGFloat
    let lineHeight: CGFloat
    
    init(
        font: ClogFont.Pretendard,
        size: CGFloat,
        lineHeight: CGFloat = 1.5
    ) {
        self.font = font
        self.size = size
        self.lineHeight = lineHeight
    }
}

public extension FontModel {
    static var h1: FontModel { FontModel(font: .semiBold, size: 24) }
    static var h2: FontModel { FontModel(font: .semiBold, size: 20) }
    static var h3: FontModel { FontModel(font: .semiBold, size: 18) }
    static var h4: FontModel { FontModel(font: .bold, size: 16) }
    static var h5: FontModel { FontModel(font: .semiBold, size: 14) }
    static var b1: FontModel { FontModel(font: .medium, size: 16) }
    static var b2: FontModel { FontModel(font: .medium, size: 14) }
    static var c1: FontModel { FontModel(font: .medium, size: 12) }
}

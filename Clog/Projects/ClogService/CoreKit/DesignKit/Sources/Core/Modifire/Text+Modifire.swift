//
//  Text+Modifire.swift
//  DesignKit
//
//  Created by Junyoung on 2/27/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct ClLogFontModifier: ViewModifier {
    private let fontModel: FontModel

    public init(_ fontModel: FontModel) {
        self.fontModel = fontModel
    }

    public func body(content: Content) -> some View {
        let font = fontModel.font.rawValue
        let fontSize = fontModel.size
        let lineHeight = fontModel.size * fontModel.lineHeight
        let lineSpacing = lineHeight - fontSize
        let verticalPadding = (lineHeight - fontSize) / 2
        
        return content
            .font(.custom(font, size: fontSize))
            .lineSpacing(lineSpacing)
            .padding(.vertical, verticalPadding)
    }
}

public extension View {
    func font(_ fontModel: FontModel) -> some View {
        self.modifier(ClLogFontModifier(fontModel))
    }
}

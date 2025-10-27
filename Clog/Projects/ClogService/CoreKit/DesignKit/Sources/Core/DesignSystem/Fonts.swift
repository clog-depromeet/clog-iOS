//
//  Fonts.swift
//  DesignKit
//
//  Created by Junyoung on 2/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import CoreText
import Foundation
import SwiftUI

import Swinject

public struct ClogFont {
    enum Pretendard: String, CaseIterable {
        case thin = "Pretendard-Thin"
        case extraLight = "Pretendard-ExtraLight"
        case light = "Pretendard-Light"
        case regular = "Pretendard-Regular"
        case medium = "Pretendard-Medium"
        case semiBold = "Pretendard-SemiBold"
        case bold = "Pretendard-Bold"
        case extraBold = "Pretendard-ExtraBold"
        case black = "Pretendard-Black"
    }
    
    public init() {}
}

extension ClogFont: Assembly {
    
    public func assemble(container: Container) {
        Pretendard.allCases.forEach { font in
            guard let fontURL = fontURL(for: font) else {
                fatalError("❌ 폰트 파일을 찾을 수 없음: \(font.rawValue)")
            }
            CTFontManagerRegisterFontsForURL(fontURL as CFURL, .process, nil)
        }
    }
    
    private func fontURL(for font: Pretendard) -> URL? {
        return Bundle.module.url(forResource: font.rawValue, withExtension: "ttf")
    }
}

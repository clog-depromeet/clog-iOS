//
//  Color.swift
//  clogUI
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

extension ClogUI where Base == UIColor {
    
    public static var white: UIColor { asset(#function) }
    public static var gray10: UIColor { asset(#function) }
    public static var gray50: UIColor { asset(#function) }
    public static var gray100: UIColor { asset(#function) }
    public static var gray200: UIColor { asset(#function) }
    public static var gray300: UIColor { asset(#function) }
    public static var gray400: UIColor { asset(#function) }
    public static var gray500: UIColor { asset(#function) }
    public static var gray600: UIColor { asset(#function) }
    public static var gray700: UIColor { asset(#function) }
    public static var gray800: UIColor { asset(#function) }
    public static var gray900: UIColor { asset(#function) }
    public static var primary: UIColor { asset(#function) }
    public static var green100: UIColor { asset(#function) }
    public static var green200: UIColor { asset(#function) }
    public static var green300: UIColor { asset(#function) }
    public static var green400: UIColor { asset(#function) }
    public static var green500: UIColor { asset(#function) }
    public static var green600: UIColor { asset(#function) }
    public static var green700: UIColor { asset(#function) }
    public static var green800: UIColor { asset(#function) }
    public static var green900: UIColor { asset(#function) }
    public static var dim: UIColor { asset(#function) }
    public static var complete: UIColor { asset(#function) }
    public static var fail: UIColor { asset(#function) }
    public static var textFail: UIColor { asset(#function) }
    public static var background: UIColor { asset(#function) }
}

extension ClogUI where Base == Color {
     
    public static var white: Color { asset(#function) }
    public static var gray10: Color { asset(#function) }
    public static var gray50: Color { asset(#function) }
    public static var gray100: Color { asset(#function) }
    public static var gray200: Color { asset(#function) }
    public static var gray300: Color { asset(#function) }
    public static var gray400: Color { asset(#function) }
    public static var gray500: Color { asset(#function) }
    public static var gray600: Color { asset(#function) }
    public static var gray700: Color { asset(#function) }
    public static var gray800: Color { asset(#function) }
    public static var gray900: Color { asset(#function) }
    public static var primary: Color { asset(#function) }
    public static var green100: Color { asset(#function) }
    public static var green200: Color { asset(#function) }
    public static var green300: Color { asset(#function) }
    public static var green400: Color { asset(#function) }
    public static var green500: Color { asset(#function) }
    public static var green600: Color { asset(#function) }
    public static var green700: Color { asset(#function) }
    public static var green800: Color { asset(#function) }
    public static var green900: Color { asset(#function) }
    public static var dim: Color { asset(#function) }
    public static var complete: Color { asset(#function) }
    public static var fail: Color { asset(#function) }
    public static var textFail: Color { asset(#function) }
    public static var background: Color { asset(#function) }
}

extension ClogUI where Base == UIColor {
    
    private static func asset(_ name: String) -> UIColor {
        let colorName = "clogUI_" + name
        guard let color = UIColor(named: colorName, in: .module, compatibleWith: nil) else {
            assertionFailure("can't find color asset: \(colorName)")
            return UIColor.clear
        }
        return color
    }
}

extension ClogUI where Base == Color {
    private static func asset(_ name: String) -> Color {
        return Color(uiColor: UIColor.clogUI.asset(name) )
    }
}

extension Color {
    public static func randomeColor() -> Color {
        return Color(
            red: CGFloat(Int.random(in: 1...255))/255,
            green: CGFloat(Int.random(in: 1...255))/255,
            blue: CGFloat(Int.random(in: 1...255))/255
        )
    }
}

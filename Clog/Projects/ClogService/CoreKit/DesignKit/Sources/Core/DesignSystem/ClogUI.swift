//
//  clogUI.swift
//  clogUI
//
//  Created by saeng lin on 2/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

public struct ClogUI<Base> {
    
    public let base: Base
    
    public init(_ base: Base) {
        self.base = base
    }
}

public protocol ClogUISupporttable {
    
    associatedtype Base
    
    static var clogUI: ClogUI<Base>.Type { get set }
    var clogUI: ClogUI<Base> { get set }
}

extension ClogUISupporttable {
    
    public var clogUI: ClogUI<Self> {
        get { ClogUI(self) }
        set { }
    }
    
    public static var clogUI: ClogUI<Self>.Type {
        get { ClogUI<Self>.self }
        set {}
    }
}

extension UIColor: ClogUISupporttable {}
extension Color: ClogUISupporttable {}

extension UIImage : ClogUISupporttable {}
extension Image: ClogUISupporttable {}
extension UIViewController: ClogUISupporttable {}

//
//  UIViewController+Extension.swift
//  DesignKit
//
//  Created by saeng lin on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import UIKit
import SwiftUI

public extension ClogUI where Base == UIViewController {
    func navigationPush<Content: View>(@ViewBuilder content: () -> Content) {
        let view = UIHostingController(rootView: content())
        base.navigationController?.pushViewController(view, animated: true)
    }
}

extension UIViewController {
    public func navigationPush<Content: View>(@ViewBuilder content: () -> Content) {
        let view = UIHostingController(rootView: content())
        self.navigationController?.pushViewController(view, animated: true)
    }
}

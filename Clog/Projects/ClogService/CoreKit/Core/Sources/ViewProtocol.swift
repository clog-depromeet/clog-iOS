//
//  ViewProtocol.swift
//  Core
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public protocol ViewProtocol: BaseViewProtocol {
}

public protocol BaseViewProtocol: View { }

public extension BaseViewProtocol {
    func makeView() -> some View { self }
}

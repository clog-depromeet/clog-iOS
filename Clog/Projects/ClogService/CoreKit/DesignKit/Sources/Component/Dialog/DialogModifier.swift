//
//  DialogModifier.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// MARK: - Modifier
struct DialogModifier: ViewModifier {
    @Binding var isPresented: Bool
    var model: DialogModel
    
    init(isPresented: Binding<Bool>, model: DialogModel) {
        self._isPresented = isPresented
        self.model = model
    }
    func body(content: Content) -> some View {
        ZStack {
            content
            
            DialogView(isPresented: $isPresented, model: model)
                .zIndex(2)

        }
    }
}

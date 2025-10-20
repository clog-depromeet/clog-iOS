//
//  Dialog+Extension.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public extension View {
    func presentDialog<Action>(
        _ item: Binding<Store<AlertState<Action>, Action>?>,
        style: DialogStyle = .default
    ) -> some View {
        let store = item.wrappedValue
        let alertState = store?.withState { $0 }
        
        return self._dialog(
            isPresented: Binding(get: { alertState != nil }, set: { if !$0 { item.wrappedValue = nil } }),
            title: (alertState?.title).map { String(state: $0) },
            message: String(state: alertState?.message ?? TextState("")),
            actions: alertState?.buttons.compactMap { button in
                DialogButtonType(
                    id: UUID(),
                    title: String(state: button.label),
                    style: style) {
                        switch button.action.type {
                        case let .send(action):
                            if let action {
                                store?.send(action)
                            }
                        case let .animatedSend(action, animation):
                            if let action {
                                store?.send(action, animation: animation)
                            }
                        }
                    }
            } ?? []
        )
    }
    
    private func _dialog(
        isPresented: Binding<Bool>,
        title: String?,
        message: String?,
        actions: [DialogButtonType]
    ) -> some View {
        let model = DialogModel(
            title: title ?? "",
            message: message ?? "",
            buttons: actions
        )
        return self.modifier(
            DialogModifier(isPresented: isPresented, model: model)
        )
    }
}

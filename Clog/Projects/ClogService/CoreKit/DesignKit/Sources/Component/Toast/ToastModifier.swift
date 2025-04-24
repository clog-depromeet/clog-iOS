//
//  ToastModifier.swift
//  DesignKit
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

struct ToastModifier: ViewModifier {
    @Binding var toast: Toast?
    @State private var workItem: DispatchWorkItem?
    @State private var isShowToast: Bool = false
    
    func body(content: Content) -> some View {
        content
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .overlay {
                ZStack {
                    toastView()
                        .offset(y: isShowToast ? 10 : -20)
                        .animation(.default, value: isShowToast)
                }
            }
            .onChange(of: toast) { _, _ in
                showToast()
            }
    }
    
    @ViewBuilder
    private func toastView() -> some View {
        if let toast = toast {
            VStack {
                ToastView(
                    message: toast.message,
                    type: toast.type
                )
                Spacer()
            }
        }
    }
    
    private func showToast() {
        guard let toast = toast else { return }
        
        isShowToast = true
        
        if toast.duration > 0 {
            workItem?.cancel()
            
            let task = DispatchWorkItem {
                dismissToast()
            }
            
            workItem = task
            DispatchQueue.main.asyncAfter(deadline: .now() + toast.duration, execute: task)
        }
    }
    
    private func dismissToast() {
        withAnimation {
            isShowToast = false
            toast = nil
        }
        workItem?.cancel()
        workItem = nil
    }
}

public extension View {
    func toast(_ toast: Binding<Toast?>) -> some View {
        self.modifier(ToastModifier(toast: toast))
    }
}

// MARK: - Preview
struct ToastExampleView : View {
    @State var showToast: Toast?

    var body: some View {
        Button {
            showToast = Toast(message: "토스트 메세지입니다 아주아주 긴\n 두 줄도 혹시 가넝?", type: .success)
        } label: {
            Text("show toast")
        }
        .toast($showToast)
    }
}

#Preview {
    ToastExampleView()
}


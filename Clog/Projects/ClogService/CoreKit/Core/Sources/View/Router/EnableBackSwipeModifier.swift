//
//  EnableBackSwipeModifier.swift
//  Core
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

struct EnableBackSwipeModifier: ViewModifier {
    @Environment(\.presentationMode) var presentationMode
    
    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .background(EnableBackSwipeHelper(presentationMode: presentationMode))
    }
}

struct EnableBackSwipeHelper: UIViewControllerRepresentable {
    var presentationMode: Binding<PresentationMode>
    
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let navigationController = uiViewController.navigationController {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
                navigationController.interactivePopGestureRecognizer?.delegate = context.coordinator
            }
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(presentationMode: presentationMode)
    }
    
    class Coordinator: NSObject, UIGestureRecognizerDelegate {
        var presentationMode: Binding<PresentationMode>
        
        init(presentationMode: Binding<PresentationMode>) {
            self.presentationMode = presentationMode
        }
        
        func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
            return true
        }
    }
}

extension View {
    func hideNavBarKeepSwipe() -> some View {
        modifier(EnableBackSwipeModifier())
    }
}

//
//  CLLogActivityIndicator.swift
//  DesignKit
//
//  Created by saeng lin on 3/31/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import UIKit

public struct CLLogActivityIndicator: UIViewRepresentable {
    @Binding var isAnimating: Bool
    let style: UIActivityIndicatorView.Style

    public init(
        isAnimating: Binding<Bool>,
        style: UIActivityIndicatorView.Style = .large
    ) {
        self._isAnimating = isAnimating
        self.style = style
    }

    public func makeUIView(
        context: Context
    ) -> UIActivityIndicatorView {
        let indicator = UIActivityIndicatorView(style: style)
        indicator.hidesWhenStopped = true
        return indicator
    }

    public func updateUIView(
        _ uiView: UIActivityIndicatorView,
        context: Context
    ) {
        isAnimating ? uiView.startAnimating() : uiView.stopAnimating()
    }
}

public struct CLLogLoadingView: View {
    @Binding var isLoading: Bool
    var message: String?

    public init(
        isLoading: Binding<Bool>,
        message: String? = nil
    ) {
        self._isLoading = isLoading
        self.message = message
    }

    public var body: some View {
        ZStack {
            if isLoading {
                Color.clogUI.gray100.opacity(0.4)
                    .edgesIgnoringSafeArea(.all)

                VStack(spacing: 16) {
                    CLLogActivityIndicator(isAnimating: $isLoading, style: .large)

                    if let message = message {
                        Text(message)
                            .font(.h5)
                            .foregroundColor(.white)
                            .font(.headline)
                    }
                }
                .padding(24)
                .background(Color.gray.opacity(0.8))
                .cornerRadius(16)
            }
        }
    }
}

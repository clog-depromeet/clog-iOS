//
//  WebView.swift
//  Core
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import UIKit
import WebKit

import ComposableArchitecture
import DesignKit

public struct WebView: View {
    
    private let store: StoreOf<WebViewFeature>
    
    public init(store: StoreOf<WebViewFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            AppBar() {
                Button {
                    store.send(.backButtonTapped)
                } label: {
                    Image.clogUI.back
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(Color.clogUI.white)
                }
                
            } rightContent: {}
            
            WebViewRepresentable(urlString: store.urlString)
                .background(Color.clogUI.gray800)
        }
    }
}

struct WebViewRepresentable: UIViewRepresentable {
    let urlString: String
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ webView: WKWebView, context: Context) {
        guard let url = URL(string: urlString) else { return }
        let request = URLRequest(url: url)
        webView.load(request)
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebViewRepresentable
        
        init(_ parent: WebViewRepresentable) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            print("웹페이지 로딩 실패: \(error.localizedDescription)")
        }
    }
}

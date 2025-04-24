//
//  SplashView.swift
//  SplashFeature
//
//  Created by Junyoung on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct SplashView: View {
    @Bindable private var store: StoreOf<SplashFeature>
    @State private var opacity: Double = 0
    
    public init(store: StoreOf<SplashFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.clogUI.gray900)
            .onAppear {
                store.send(.onAppear)
                withAnimation(.easeInOut(duration: 1)) {
                    opacity = 1
                } completion: {
                    store.send(.animationFinished)
                }
            }
            .presentDialog($store.scope(state: \.alert, action: \.alert), style: .default)
    }
}

extension SplashView {
    private func makeBody() -> some View {
        ZStack(alignment: .center) {
            Image.clogUI.clogLogo
                .resizable()
                .frame(width: 183 ,height: 106)
                .opacity(opacity)
        }
    }
}

#Preview {
    SplashView(store: .init(initialState: SplashFeature.State(), reducer: {
        SplashFeature()
    }))
}

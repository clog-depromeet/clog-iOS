//
//  SocialView.swift
//  SocialFeature
//
//  Created by 강현준 on 5/16/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import SwiftUI
import ComposableArchitecture

import DesignKit

public struct SocialView: View {
    
    @Bindable private var store: StoreOf<SocialFeature>
    
    public init(
        store: StoreOf<SocialFeature>
    ){
        self.store = store
    }
    
    public var body: some View {
        Color.red
            .background(Color.clogUI.gray800)
    }
}

#Preview {
    SocialView(
        store: Store(
            initialState: SocialFeature.State(),
            reducer: {
                SocialFeature()
            }
        )
    )
}

//
//  AddAttemptsView.swift
//  AddAttemptsFeature
//
//  Created by soi on 5/24/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public struct AddAttemptsView: View {
    @Bindable private var store: StoreOf<AddAttemptsFeature>
    
    public init(store: StoreOf<AddAttemptsFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text("Attempts 추가")
    }
}

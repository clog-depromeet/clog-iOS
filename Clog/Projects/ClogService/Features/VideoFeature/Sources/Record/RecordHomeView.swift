//
//  RecordView.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

// Apple Module
import UIKit
import SwiftUI

// 내부 Module
import DesignKit

// 외부 Module
import ComposableArchitecture
import DesignKit

public struct RecordHomeView: View {
    
    private weak var on: UIViewController?
    private let store: StoreOf<RecordHomeFeature>
    
    public init(
        on: UIViewController? = nil,
        store: StoreOf<RecordHomeFeature>
    ) {
        self.on = on
        self.store = store
    }
    
    public var body: some View {
        bodyView
            .onAppear {
                store.send(.onAppear)
            }
    }
    
    private var bodyView: some View {
        ZStack {
            IfLetStore(store.scope(state: \.recordingState, action: \.recordingAction)) { store in
                RecordingView(store: store)
            }
            
            IfLetStore(store.scope(state: \.recordedState, action: \.recordedAction)) { [weak on] store in
                RecordedView(on: on, store: store)
            }
        }
    }
}

#Preview {
    RecordHomeView(on: nil, store: .init(
        initialState: RecordHomeFeature.State(),
        reducer: {
            RecordHomeFeature()
        }))
}

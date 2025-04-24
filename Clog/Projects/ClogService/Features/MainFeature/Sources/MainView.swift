//
//  Sample.swift
//  Sample
//
//  Created by Junyoung on 1/8/25.
//

import UIKit
import SwiftUI

import DesignKit

import ComposableArchitecture
//
//public struct MainView: View {
//
//    private weak var on: UIViewController?
//    private let tabViews: [AnyView]
//    private var overlayerView: AnyView
//    private let store: StoreOf<MainFeature>
//
//    @State private var selectedTab = 1
//
//    public init(
//        on: UIViewController?,
//        tabViews: [any View],
//        overlayerView: any View,
//        store: StoreOf<MainFeature>
//    ) {
//        self.on = on
//        self.tabViews = tabViews.map { AnyView($0) }
//        self.overlayerView = AnyView(overlayerView)
//        self.store = store
//    }
//
//    public var body: some View {
//        bodyView
//            .overlay {
//                if store.showOverlay {
//                    overlayerView
//                }
//            }
//    }
//
//    private var bodyView: some View {
//        TabView(selection: $selectedTab) {
//            ForEach(Array(tabViews.enumerated()), id: \.offset) { index, view in
//                view
//                    .tabItem {
//                        Image(
//                            selectedTab == index ? "\(store.selectedImageNames[index])":
//                                "\(store.unselectedImageNames[index])",
//                            bundle: .clogUIBundle
//                        )
//                    }
//                    .toolbarBackground(Color.clogUI.gray700, for: .tabBar)
//                    .toolbarBackground(.visible, for: .tabBar)
//            }
//            .onAppear {
//                store.send(.onAppear)
//            }
//        }
//    }
//}

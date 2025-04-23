import SwiftUI

import SettingFeature
import ComposableArchitecture

@main
struct SettingApp: App {
    
    var body: some Scene {
        WindowGroup {
            SettingView(
                store: .init(
                    initialState: SettingFeature.State(),
                    reducer: {
                        SettingFeature()
                    }
                )
            )
        }
    }
}

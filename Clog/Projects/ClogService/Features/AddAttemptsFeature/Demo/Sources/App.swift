import SwiftUI

import AddAttemptsFeature
import AddAttemptsFeatureInterface

@main
struct AddAttemptsApp: App {
    var body: some Scene {
        WindowGroup {
            AddAttemptsView(
                store: .init(
                    initialState: AddAttemptsFeature.State(),
                    reducer: {
                        AddAttemptsFeature()
                    }
                )
            )
        }
    }
}

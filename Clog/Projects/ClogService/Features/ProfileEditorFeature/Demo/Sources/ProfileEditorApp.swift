import SwiftUI
import ProfileEditorFeature
import ProfileEditorFeatureInterface

@main
struct ProfileEditorApp: App {
    var body: some Scene {
        WindowGroup {
            ProfileEditorView(
                store: .init(
                    initialState: ProfileEditorFeature.State(),
                    reducer: {
                        ProfileEditorFeature()
                    }
                )
            )
        }
    }
}

import SwiftUI
import FolderFeature

@main
struct FolderDemoApp: App {
    var body: some Scene {
        WindowGroup {
            FolderView(
                store: .init(
                    initialState: FolderFeature.State(),
                    reducer: {
                        FolderFeature()
                    }
                )
            )
        }
    }
}

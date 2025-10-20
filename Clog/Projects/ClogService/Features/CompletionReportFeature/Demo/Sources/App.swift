import SwiftUI
import CompletionReportFeature
@main
struct CompletionReportApp: App {
    
    var body: some Scene {
        WindowGroup {
            CompletionReportView(
                store: .init(
                    initialState: CompletionReportFeature.State(storyId: 0),
                    reducer: {
                        CompletionReportFeature()
                    }
                )
            )
        }
    }
}

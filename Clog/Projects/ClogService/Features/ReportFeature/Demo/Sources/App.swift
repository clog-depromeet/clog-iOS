import SwiftUI
import ReportFeature

@main
struct ReportApp: App {
    var body: some Scene {
        WindowGroup {
            ReportView(store: .init(initialState: ReportFeature.State(), reducer: {
                ReportFeature()
            }))
        }
    }
}

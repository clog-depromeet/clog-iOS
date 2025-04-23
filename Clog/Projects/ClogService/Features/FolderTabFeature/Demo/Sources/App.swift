import SwiftUI
import FolderTabFeature
import Core

@main
struct AppModule: App {
    var body: some Scene {
        WindowGroup {
            FolderTabView(
                store: .init(
                    initialState: FolderTabFeature.State(),
                    reducer: {
                        FolderTabFeature()
                    }
                ),
                folderView: TestView1(),
                calendarView: TestView2()
            )
        }
    }
}

struct TestView1: ViewProtocol {
    var body: some View {
        Text("Test")
    }
}

struct TestView2: ViewProtocol {
    var body: some View {
        Text("Test")
    }
}

import SwiftUI

import SocialFeature
import ComposableArchitecture

@main
struct SocialApp: App {
    
    var body: some Scene {
        WindowGroup {
            SocialView(
                store: .init(
                    initialState: SocialFeature.State(),
                    reducer: {
                        SocialFeature()
                    }
                )
            )
        }
    }
}

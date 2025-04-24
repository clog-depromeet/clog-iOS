import SwiftUI
import LoginFeature

import ComposableArchitecture

@main
struct LoginApp: App {
    
    static let store = Store(initialState: LoginFeature.State()) {
        LoginFeature(useCase: <#any LoginUseCase#>)
    }
    
    var body: some Scene {
        WindowGroup {
            LoginView(
                on: nil,
                store: LoginApp.store
            )
        }
    }
}

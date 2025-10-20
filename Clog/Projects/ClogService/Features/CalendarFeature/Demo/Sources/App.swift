import SwiftUI

import CalendarFeature
import CalendarDomain
import Shared

@main
struct CalendarDemoApp: App {
    
    init() {
        ClogDI.container.register(FutureMonthCheckerUseCase.self) { _ in
            FutureMonthChecker()
        }
    }
    
    var body: some Scene {
        WindowGroup {
            CalendarMainView(
                store: .init(
                    initialState: CalendarMainFeature.State(),
                    reducer: {
                        CalendarMainFeature()
                    }
                )
            )
            
//            CalendarDetailView(
//                store: .init(
//                    initialState: CalendarDetailFeature.State(),
//                    reducer: {
//                        CalendarDetailFeature()
//                    }
//                )
//            )
        }
    }
}

//
//  ClogWindow.swift
//  Clog
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI
import ClogService
import Starlink

import Dependencies

final class ClogWindow: UIWindow {

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        if ClogPhase.current == .dev {
            ConsoleWindow.shared.showOverlay()
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if ClogPhase.current == .dev, motion == .motionShake, ConsoleWindow.shared.isShowing == false {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
            ConsoleWindow.shared.showOverlay()
        }
        super.motionEnded(motion, with: event)
    }
}

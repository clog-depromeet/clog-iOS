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

import Dependencies

final class ClogWindow: UIWindow {

    override init(windowScene: UIWindowScene) {
        super.init(windowScene: windowScene)
        if ClogPhase.current == .dev {
            
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if ClogPhase.current == .dev, motion == .motionShake {
            let generator = UINotificationFeedbackGenerator()
            generator.prepare()
            generator.notificationOccurred(.success)
        }
        super.motionEnded(motion, with: event)
    }
}

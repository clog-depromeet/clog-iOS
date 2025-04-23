//
//  ConsoleWindow.swift
//  Starlink
//
//  Created by saeng lin on 2/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import UIKit
import SwiftUI

import Pulse
import PulseUI

public class ConsoleWindow {
    public static let shared = ConsoleWindow()
    fileprivate var overlayWindow: UIWindow?
    
    public var isShowing: Bool { overlayWindow != nil }

    public func showOverlay() {
        
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene else { return }
    
        let newWindowFrame = CGRect(origin: .init(x: 40, y: 40), size: CGSize(width: 300, height: 400))
        

        let newWindow = UIWindow(windowScene: windowScene)
        newWindow.frame = newWindowFrame
        newWindow.windowLevel = .alert + 1
        newWindow.backgroundColor = .clear
        
        newWindow.rootViewController = ConsoleViewController()
        newWindow.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        newWindow.makeKeyAndVisible()
  
        self.overlayWindow = newWindow
    }
    
    public func hideOverlay() {
        overlayWindow?.isHidden = true
        overlayWindow = nil
    }
    
    /// ConsoleMessage
    /// - Parameters:
    ///   - label: label
    ///   - level: 정보레벨
    ///   - message: 메세지
    public func message(label: String = "", level: LoggerStore.Level = .debug, message: String) {
        LoggerStore.shared.storeMessage(
            label: label,
            level: level,
            message: message
        )
        
        print("\(message)")
    }
}

class ConsoleViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan(_:)))
        view.addGestureRecognizer(panGesture)
        
        let hostingController = UIHostingController(rootView: StarlinkConsoleView())
        addChild(hostingController)
        
        hostingController.view.frame = .init(x: view.frame.origin.x, y: view.frame.origin.y, width: view.bounds.width, height: view.bounds.height)
        hostingController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(hostingController.view)
        hostingController.didMove(toParent: hostingController)
    
        hostingController.view.backgroundColor = UIColor.black.withAlphaComponent(0.5)
    
        let closeButton = UIButton(type: .system)
        closeButton.backgroundColor = .lightGray
        closeButton.setTitle("닫기", for: .normal)
        closeButton.setTitleColor(.black, for: .normal)
        closeButton.addTarget(self, action: #selector(closeOverlay), for: .touchUpInside)
        closeButton.frame = CGRect(x: 10, y: view.bounds.height - 30, width: 60, height: 30)
        view.addSubview(closeButton)
        
        hostingController.view.layer.borderColor = UIColor.black.cgColor
        hostingController.view.layer.borderWidth = 1.0
    }
    
    @objc
    private func handlePan(_ gesture: UIPanGestureRecognizer) {
        guard let window = view.window else { return }
        let translation = gesture.translation(in: window)
        var newFrame = window.frame
        newFrame.origin.x += translation.x
        newFrame.origin.y += translation.y
        window.frame = newFrame
        gesture.setTranslation(.zero, in: window)
    }
    
    @objc
    private func closeOverlay() {
        ConsoleWindow.shared.hideOverlay()
    }
}

struct StarlinkConsoleView: View {
    
    init() {}
    
    var body: some View {
        NavigationView {
            ConsoleView()
        }
    }
}


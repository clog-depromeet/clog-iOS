//
//  InstagramShared.swift
//  FolderFeature
//
//  Created by saeng lin on 3/31/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import UIKit
import MobileCoreServices

class InstagramSharerViewController: UIViewController, UIDocumentInteractionControllerDelegate {
    private var fileURL: URL?
    private var uti: String?
    private var documentController: UIDocumentInteractionController?
    private let isPresented: Binding<Bool>

    init(
        fileURL: URL?,
        uti: String?,
        isPresented: Binding<Bool>
    ) {
        self.fileURL = fileURL
        self.uti = uti
        self.isPresented = isPresented
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        guard let fileURL else { return }

        documentController = UIDocumentInteractionController(url: fileURL)
        documentController?.delegate = self
        documentController?.uti = uti
        documentController?.presentOpenInMenu(from: self.view.frame, in: self.view, animated: true)
    }

    func documentInteractionControllerDidDismissOpenInMenu(_ controller: UIDocumentInteractionController) {
        isPresented.wrappedValue = false
    }
}

public struct InstagramSharerView: UIViewControllerRepresentable {
    @Binding var isPresented: Bool
    private let uti: String?
    private let filePath: URL?

    public init(filePath: URL?, uti: String?, isPresented: Binding<Bool>) {
        self.filePath = filePath
        self.uti = uti
        self._isPresented = isPresented
    }

    public func makeUIViewController(context: Context) -> UIViewController {
        return InstagramSharerViewController(fileURL: filePath, uti: uti, isPresented: $isPresented)
    }

    public func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}

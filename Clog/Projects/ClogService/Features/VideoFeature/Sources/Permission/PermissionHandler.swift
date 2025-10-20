//
//  PermissionHandler.swift
//  VideoFeature
//
//  Created by Junyoung on 4/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation
import Photos


public enum PermissionError: Error {
    case denied
}

public protocol PermissionHandler {
    func requestPermission() async throws
}

final class VideoPermissionHandler: PermissionHandler {
    init() {}
    
    func requestPermission() async throws {
        try await requestCameraPermission()
        try await requestMicrophonePermission()
        try await requestPhotoLibraryPermission()
    }
    
    private func requestCameraPermission() async throws {
        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if currentStatus == .authorized {
            return
        }
        
        try await withCheckedThrowingContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    continuation.resume(returning: ())
                } else {
                    continuation.resume(throwing: PermissionError.denied)
                }
            }
        }
    }
    
    private func requestMicrophonePermission() async throws {
        if AVAudioApplication.shared.recordPermission == .granted {
            return
        }
        try await withCheckedThrowingContinuation { continuation in
            AVAudioApplication.requestRecordPermission(completionHandler: { granted in
                if granted {
                    continuation.resume()
                } else {
                    continuation.resume(throwing: PermissionError.denied)
                }
            })
        }
    }
    
    private func requestPhotoLibraryPermission() async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return
        case .restricted, .denied, .notDetermined:
            throw PermissionError.denied
        @unknown default:
            break
        }
    }
}

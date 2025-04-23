//
//  VideoPermissionUseCase.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

import Shared

import Dependencies
import Photos

public protocol VideoPermissionUseCase: Sendable {
    func execute() async throws
}

public struct VideoPermission: VideoPermissionUseCase {
    
    public init() {}
    
    public func execute() async throws {
        try await checkVideoPermission()
        try await checkMicrophonePermission()
        try await checkPhotoLibraryPermission()
    }
    
    private func checkVideoPermission() async throws {
        let currentStatus = AVCaptureDevice.authorizationStatus(for: .video)
        if currentStatus == .authorized {
            return
        }
        
        try await withCheckedThrowingContinuation { continuation in
            AVCaptureDevice.requestAccess(for: .video) { granted in
                if granted {
                    continuation.resume(returning: ())
                } else {
                    let error = NSError(
                        domain: "VideoPermission",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Camera permission denied."]
                    )
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    private func checkMicrophonePermission() async throws {
        
        if AVAudioApplication.shared.recordPermission == .granted {
            return
        }
        try await withCheckedThrowingContinuation { continuation in
            AVAudioApplication.requestRecordPermission(completionHandler: { granted in
                if granted {
                    continuation.resume()
                } else {
                    let error = NSError(
                        domain: "CapturePermission",
                        code: 1,
                        userInfo: [NSLocalizedDescriptionKey: "Microphone permission denied."]
                    )
                    continuation.resume(throwing: error)
                }
            })
        }
    }
    
    private func checkPhotoLibraryPermission() async throws {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        switch status {
        case .authorized, .limited:
            return
        case .restricted, .denied, .notDetermined:
            let error = NSError(
                domain: "CapturePermission",
                code: 1,
                userInfo: [NSLocalizedDescriptionKey: "Microphone permission denied."]
            )
            throw error
        @unknown default:
            break
        }
    }
}

public struct MockVideoPermission: VideoPermissionUseCase {
    public func execute() async throws {
        
    }
}

public enum VideoPermissionDepdencyKey: DependencyKey {
    public static var liveValue: any VideoPermissionUseCase = VideoPermission()
//    public static var testValue: any VideoPermissionUseCase = MockVideoPermission()
//    public static var previewValue: any VideoPermissionUseCase = MockVideoPermission()
}

public extension DependencyValues {
    var videoPermission: any VideoPermissionUseCase {
        get { self[VideoPermissionDepdencyKey.self] }
        set { self[VideoPermissionDepdencyKey.self] = newValue }
    }
}

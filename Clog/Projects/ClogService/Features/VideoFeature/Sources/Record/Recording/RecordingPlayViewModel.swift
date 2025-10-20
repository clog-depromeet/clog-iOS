//
//  RecordingPlayViewModel.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation

public class RecordingPlayViewModel: NSObject, ObservableObject {
    
    @Published private(set) var session = AVCaptureSession()
    private var movieOutput: AVCaptureMovieFileOutput = .init()
    private let sessionQueue = DispatchQueue(label: "RecordingPlay.Session.Queue")
    
    private var recordingOutputStream: AsyncStream<(AVCaptureFileOutput?, URL, [AVCaptureConnection], (any Error)?)>.Continuation?
    public private(set) lazy var recordingOutputAsyncStream: AsyncStream<(AVCaptureFileOutput?, URL, [AVCaptureConnection], (any Error)?)> = AsyncStream { [weak self] in
        self?.recordingOutputStream = $0
    }
    
    deinit {
        print("deinit : \(Self.self)")
    }

    override init() {
        super.init()
        setupSession()
    }
    
    private func setupSession() {
        session.beginConfiguration()
        
        if session.canSetSessionPreset(.hd1920x1080) {
            session.sessionPreset = .hd1920x1080
        } else if session.canSetSessionPreset(.high) {
            session.sessionPreset = .high
        } else {
            session.sessionPreset = .medium
        }
        
        guard let videoDevice = AVCaptureDevice.default(for: .video),
              let audioDevice = AVCaptureDevice.default(for: .audio) else {
            return
        }

        do {
            let videoInput = try AVCaptureDeviceInput(device: videoDevice)
            if session.canAddInput(videoInput) {
                session.addInput(videoInput)
            }
            
            let audioInput = try AVCaptureDeviceInput(device: audioDevice)
            if session.canAddInput(audioInput) {
                session.addInput(audioInput)
            }

            if session.canAddOutput(self.movieOutput) {
                session.addOutput(self.movieOutput)
            }
            
            session.commitConfiguration()
            
        } catch {
            print("캡쳐 세션 설정 에러: \(error)")
        }
    }
    
    /// 카메라 session on
    public func startSession() {
        #if !targetEnvironment(simulator)
        sessionQueue.asyncAfter(deadline: .now() + 0.3, execute: { [weak session] in
            guard let session else { return }
            guard !session.isRunning else {  return }
            session.startRunning()
        })
        #endif
    }
    
    /// 카메라 session off
    public func stopSession() async {
        #if !targetEnvironment(simulator)
        return await withCheckedContinuation { [weak sessionQueue] continuation in
            sessionQueue?.sync { [weak session] in
                guard let session else { return }
                guard session.isRunning else {  return }
                session.stopRunning()
                
                continuation.resume()
            }
        }
        #endif
    }
    
    
    /// 카메라 Recording on
    /// - Parameter fileURL: 저장 할 파일 URL
    public func startRecording(to fileURL: URL) {
        #if !targetEnvironment(simulator)
        sessionQueue.asyncAfter(deadline: .now() + 0.4, execute: { [weak movieOutput] in
            guard let movieOutput else { return }
            guard !movieOutput.isRecording else { return }
            movieOutput.startRecording(to: fileURL, recordingDelegate: self)
        })
        #endif
    }
    
    public func stopRecording() {
        #if !targetEnvironment(simulator)
        sessionQueue.async { [weak movieOutput] in
            guard let movieOutput else { return }
            guard movieOutput.isRecording else { return }
            movieOutput.stopRecording()
        }
        #else
        recordingOutputStream?.yield(
            (nil, URL(string: "https://www.naver.com")!, [], nil)
        )
        #endif
    }
}

extension RecordingPlayViewModel: AVCaptureFileOutputRecordingDelegate {
    
    public func fileOutput(
        _ output: AVCaptureFileOutput,
        didFinishRecordingTo outputFileURL: URL,
        from connections: [AVCaptureConnection],
        error: (any Error)?
    ) {
        recordingOutputStream?.yield((output, outputFileURL, connections, error))
    }
}

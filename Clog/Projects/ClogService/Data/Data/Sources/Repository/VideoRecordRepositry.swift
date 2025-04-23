//
//  VideoRecordRepositry.swift
//  Data
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import VideoDomain

import Networker
import Starlink
import Swinject
import Photos

public struct VideoRecordRepository: VideoRepository {

    private let dataSource: VideoDataSourceLogic
    
    public init(
        dataSource: VideoDataSourceLogic
    ) {
        self.dataSource = dataSource
    }
    
    
    /// 비디오 저장 기능 - path
    /// - Parameter fileURL: 비디오 경로
    public func saveVideo(fileURL: URL) async throws -> String {
        do {
            let videoAssetId = try await saveVideoToPhotoLibrary(from: fileURL)
            print("✅ 사진첩에 성공적으로 저장되었습니다")
            return videoAssetId
        } catch {
            print("파일 저장 중 에러 발생: \(error.localizedDescription)")
            throw VideoError.saveFailed
        }
    }
    
    /// 비디오 읽어오는 기능 - 테스트
    /// - Parameter fileName: 파일명 (path xxxx) - RecordingFeature에서 저장된 fileName
    /// - Returns: 저장된 path
    public func readSavedVideo(fileName: String) async throws -> URL {
        let fileManager = FileManager.default
        
        // 앱의 Documents 디렉토리 경로 가져오기
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Documents 디렉토리를 찾을 수 없습니다.")
            throw VideoError.notFoundDirectory
        }
        
        // 파일 경로 생성
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        
        // 파일 존재 여부 확인
        if fileManager.fileExists(atPath: fileURL.path) {
            do {
                // 파일 데이터를 읽어옵니다.
                let data = try Data(contentsOf: fileURL)
                print("파일 읽기 성공: \(fileURL)")
                return fileURL
            } catch {
                print("파일 읽기 중 에러 발생: \(error.localizedDescription)")
                throw VideoError.readFailed
            }
        } else {
            print("파일이 존재하지 않습니다: \(fileURL)")
            throw VideoError.notFoundFile
        }
    }
    
    public func uploadVideoThumbnail(
        fileName: String,
        mimeType: String,
        value: Data
    ) async throws -> String {
        let request = ThumbnailPreSignedUploadRequestDTO(
            originalFilename: fileName,
            contentType: mimeType
        )
        do {
            let authenticateResponse = try await dataSource.authenticate(request)
            
            try await dataSource.thumbnailUpload(
                preSignedURL: authenticateResponse.presignedUrl,
                data: value
            )
            
            return authenticateResponse.fileUrl
        } catch {
            throw VideoError.uploadFailed
        }
    }
    
    private func saveVideoToPhotoLibrary(from fileURL: URL) async throws -> String {
        let status = await PHPhotoLibrary.requestAuthorization(for: .readWrite)
        
        guard status == .authorized || status == .limited else {
            print("📛 사진첩 접근 권한 없음")
            throw VideoError.savePhotoDenied
        }
        
        return try await withCheckedThrowingContinuation { continuation in
            var assetId: String?
            PHPhotoLibrary.shared().performChanges({
                let options = PHAssetResourceCreationOptions()
                let creationRequest = PHAssetCreationRequest.forAsset()
                creationRequest.addResource(with: .video, fileURL: fileURL, options: options)
                assetId = creationRequest.placeholderForCreatedAsset?.localIdentifier
                
            }, completionHandler: { success, error in
                if success {
                    print("✅ 동영상 사진첩에 저장 완료!")
                    if let assetId {
                        print("assetId: \(assetId)") // 사진첩 assetID
                        continuation.resume(returning: assetId)
                    } else {
                        continuation.resume(throwing: VideoError.notFoundAsset)
                    }
                } else {
                    print("❌ 저장 실패:", error?.localizedDescription ?? "알 수 없는 오류")
                    continuation.resume(throwing: VideoError.saveFailed)
                }
            })
        }
    }
}

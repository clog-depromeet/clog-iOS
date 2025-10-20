//
//  VideoRepository.swift
//  VideoDomain
//
//  Created by saeng lin on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol VideoRepository: Sendable {
    
    /// 영상을 저장하는 인터페이스
    func saveVideo(fileURL: URL) async throws -> String
    
    /// 영상을 불러오는 인터페이스
    func readSavedVideo(fileName: String) async throws -> URL
    
    /// 영상을 업로드 하는 인터페이스
    func uploadVideoThumbnail(
        fileName: String,
        mimeType: String,
        value: Data
    ) async throws -> String
}

//
//  VideoUploadResponseDTO.swift
//  Data
//
//  Created by saeng lin on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import VideoDomain


public struct VideoThumbnailUploadResponseDTO: Decodable {
    public let presignedUrl: String
    public let fileUrl: String
    
    public init(
        presignedUrl: String,
        fileUrl: String
    ) {
        self.presignedUrl = presignedUrl
        self.fileUrl = fileUrl
    }
    
    func toDomain() -> VideoThumbnails {
        return VideoThumbnails(
            preSignedUrl: presignedUrl,
            fileUrl: fileUrl
        )
    }
}

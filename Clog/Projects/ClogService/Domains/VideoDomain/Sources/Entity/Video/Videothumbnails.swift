//
//  Videothumbnails.swift
//  VideoDomain
//
//  Created by saeng lin on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct VideoThumbnails {
    public let preSignedUrl: String
    public let fileUrl: String
    
    public init(
        preSignedUrl: String,
        fileUrl: String
    ) {
        self.preSignedUrl = preSignedUrl
        self.fileUrl = fileUrl
    }
}

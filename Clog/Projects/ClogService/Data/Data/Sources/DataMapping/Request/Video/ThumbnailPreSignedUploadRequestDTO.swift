//
//  ThumbnailPreSignedUploadRequestDTO.swift
//  Data
//
//  Created by Junyoung on 4/10/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct ThumbnailPreSignedUploadRequestDTO: Encodable {
    let originalFilename: String
    let contentType: String
}

//
//  EdittedVideo.swift
//  EditDomain
//
//  Created by seunghwan Lee on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public struct Video {
    public let videoUrl: URL
    public let videoDuration: Double?
    public let stampTimeList: [Double]
    
    public init(videoUrl: URL, videoDuration: Double? = nil, stampTimeList: [Double]) {
        self.videoUrl = videoUrl
        self.videoDuration = videoDuration
        self.stampTimeList = stampTimeList
    }
}

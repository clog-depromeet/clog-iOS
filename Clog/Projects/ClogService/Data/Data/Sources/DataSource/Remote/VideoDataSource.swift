//
//  VideoDataSource.swift
//  Data
//
//  Created by saeng lin on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

@preconcurrency import Moya

import Networker
import VideoDomain

public protocol VideoDataSourceLogic: Sendable {
    /// S3에 직접 업로드 하기 위한 인증
    func authenticate(_ request: ThumbnailPreSignedUploadRequestDTO) async throws -> VideoThumbnailUploadResponseDTO
    func thumbnailUpload(preSignedURL: String, data: Data) async throws
}

public struct VideoDataSource: VideoDataSourceLogic {
    
    private let authorizedProvider: MoyaProvider<VideoTarget>
    private let plainProvider: MoyaProvider<VideoTarget>
    
    public init() {
        self.authorizedProvider = MoyaProvider<VideoTarget>.authorized()
        self.plainProvider = MoyaProvider<VideoTarget>.plain()
    }
    
    public func authenticate(
        _ request: ThumbnailPreSignedUploadRequestDTO
    ) async throws -> VideoThumbnailUploadResponseDTO {
        let response: BaseResponseDTO<VideoThumbnailUploadResponseDTO> = try await authorizedProvider.request(VideoTarget.authenticate(request))

        guard let data = response.data else {
            throw NetworkError.decoding
        }
        
        return data
    }
    
    public func thumbnailUpload(preSignedURL: String, data: Data) async throws {
        try await plainProvider.request(
            VideoTarget.upload(
                preSignedURL: preSignedURL,
                data: data
            )
        )
    }
}

enum VideoTarget {
    case authenticate(ThumbnailPreSignedUploadRequestDTO)
    case upload(preSignedURL: String, data: Data)
}

extension VideoTarget: TargetType {
    
    var baseURL: URL {
        switch self {
        case .authenticate:
            return URL(string: Environment.baseURL + "/api/v1/thumbnails")!
        case .upload(let url, _):
            return URL(string: url)!
        }
    }
    
    var path: String {
        switch self {
        case .authenticate:
            return "/upload-url"
        case .upload:
            return ""
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .authenticate:
            return .post
        case .upload:
            return .put
        }
    }
    
    var task: Task {
        switch self {
        case .authenticate(let request):
            return .requestJSONEncodable(request)
        case .upload(_, let data):
            return .requestData(data)
        }
    }
    
    var headers: [String : String]? {
        switch self {
        case .upload:
            return ["Content-Type": "image/png"]
        case .authenticate:
            return Headers.contentJson
        }
    }
    
    var validationType: ValidationType { .successCodes }
}

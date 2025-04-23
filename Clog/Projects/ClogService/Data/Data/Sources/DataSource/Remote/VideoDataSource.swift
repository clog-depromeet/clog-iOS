//
//  VideoDataSource.swift
//  Data
//
//  Created by saeng lin on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Starlink
import Networker
import Alamofire
import VideoDomain

public protocol VideoDataSourceLogic: Sendable {
    /// S3에 직접 업로드 하기 위한 인증
    func authenticate(_ request: ThumbnailPreSignedUploadRequestDTO) async throws -> VideoThumbnailUploadResponseDTO
    func thumbnailUpload(preSignedURL: String, data: Data) async throws
}

public struct VideoDataSource: VideoDataSourceLogic {
    
    private let authProvider: AuthProvider
    
    public init(authProvider: AuthProvider) {
        self.authProvider = authProvider
    }
    
    public func authenticate(
        _ request: ThumbnailPreSignedUploadRequestDTO
    ) async throws -> VideoThumbnailUploadResponseDTO {
        let response: BaseResponseDTO<VideoThumbnailUploadResponseDTO> = try await authProvider.request(VideoEndPoint.authenticate(request))

        guard let data = response.data else {
            throw StarlinkError.inValidJSONData(nil)
        }
        
        return data
    }
    
    public func thumbnailUpload(preSignedURL: String, data: Data) async throws {
        do {
            _ = try await AF.upload(
                data,
                to: preSignedURL,
                method: .put,
                headers: .init([HTTPHeader(name: "Content-Type", value: "image/png")])
            )
            .validate(statusCode: 200 ..< 300)
            .serializingDecodable(Empty.self, emptyResponseCodes: Set(200 ..< 300))
            .value
        } catch {
            print("failure : \(error)")
            throw VideoError.uploadFailed
        }
    }
}

public enum VideoEndPoint: EndpointType {
    case authenticate(ThumbnailPreSignedUploadRequestDTO)
    
    public var baseURL: String {
        return Environment.baseURL
    }
    public var path: String {
        switch self {
        case .authenticate:
            return "/api/v1/thumbnails/upload-url"
        }
    }
    
    public var method: Starlink.Method {
        switch self {
        case .authenticate:
            return .post
        }
    }
    
    public var parameters: ParameterType? {
        switch self {
        case .authenticate(let request):
            return .encodable(request)
        }
    }
    public var encodable: (any Encodable)? {
        switch self {
        case .authenticate:
            return nil
        }
    }
    public var headers: [Starlink.Header]? {
        switch self {
        case .authenticate:
            return nil
        }
    }
    
    public var encoding: StarlinkEncodable {
        switch self {
        case .authenticate:
            return Starlink.StarlinkJSONEncoding()
        }
    }
}

struct EmptyModel: Encodable {}

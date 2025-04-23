//
//  Request.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

import Combine

public protocol StarlinkRequest {
    func reponsePublisher<T: Decodable>() -> AnyPublisher<T, any Error>
    func reponseAsync<T: Decodable>() async throws -> T
    func response<T: Decodable>(_ complete: @escaping @Sendable (Result<T, any Error>) -> Void)
    func uploadResponse<T: Decodable>(retryURLRequest: URLRequest?) async throws -> T
}

extension Starlink {

    public final class Request: @unchecked Sendable {
        public let session: Sessionable
        public let path: URLConversion
        public let params: SafeDictionary<String, Any>?
        public let method: Method
        public let headers: [Starlink.Header]
        public let requestTime: Date
        let trakers: SafeTrackers
        let interceptors: [any StarlinkInterceptor]
        let encoding: (any StarlinkEncodable)
        var uploadForm: UploadDataForm? = nil
        var retryLimit: Int = 1
        var retryCount: Int = 0

        /// 초기화
        /// - Parameters:
        ///   - session: URLSession
        ///   - method: REST full Method
        ///   - path: api path
        ///   - requestTime: 요청 시간
        init(
            session: Sessionable,
            path: URLConversion,
            params: SafeDictionary<String, Any>? = nil,
            uploadForm: UploadDataForm? = nil,
            method: Method,
            headers: [Starlink.Header] = [],
            requestTime: Date = Date(),
            trakers: SafeTrackers,
            interceptors: [any StarlinkInterceptor] = [],
            encoding: (any StarlinkEncodable)
        ) {
            self.session = session
            self.path = path
            self.params = params
            self.uploadForm = uploadForm
            self.method = method
            self.headers = headers
            self.requestTime = requestTime
            self.trakers = trakers
            self.interceptors = interceptors
            self.encoding = encoding
        }
    }
}


public extension URLRequest {
    mutating func setHeaders(_ headers: [Starlink.Header]) {
        headers.forEach { self.setHeader($0) }
    }
    
    mutating func setHeader(_ header: Starlink.Header) {
        self.setValue(header.value, forHTTPHeaderField: header.name)
    }
}

public protocol URLConversion: Sendable {
    func asURL() throws -> URL
}

extension String: URLConversion {
    public func asURL() throws -> URL {
        guard let url = URL(string: self) else {
            throw NSError(domain: "InValid URL", code: -999)
        }
        return url
    }
    
}

extension URL: URLConversion {
    public func asURL() throws -> URL {
        return self
    }
}

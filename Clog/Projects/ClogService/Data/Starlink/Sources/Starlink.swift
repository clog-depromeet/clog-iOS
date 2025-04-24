//
//  Starlink.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

import Pulse

extension Starlink {
    
    // default
    public static var session: Starlink {
        let configure = Starlink.default()
        return Starlink(
            session: URLSessionProxy(configuration: .default, delegate: configure.delegate)
        )
        .option([
            StarlinkLogTraking()
        ])
    }
}

public final class Starlink: @unchecked Sendable {
    
    private let session: Sessionable
    private let trackers: SafeTrackers = .init()
    private let interceptors: [any StarlinkInterceptor]
    
    /// 초기화
    /// - Parameter configure: Configuration ( URLSession Configure - Service 별로 주입 필요)
    public init(
        session: Sessionable,
        interceptors: [any StarlinkInterceptor] = []
    ) {
        self.session = session
        self.interceptors = interceptors
        self.trackers.append([StarlinkLogTraking()])
    }
    
    /// 네트워크 중간에 tracking을 하기 위해서 추가
    /// - Parameter trackers: 트랙킹 구현체 리스트
    /// - Returns: 트랙킹이 추가 된 네트워크 객체
    public func option(
        _ trackers: [any StarlinkTracking]
    ) -> Starlink {
        self.trackers.append(trackers)
        return self
    }
    
    /// Starlink.Request ( URL Session을 요청하는 Request 생성 )
    /// - Parameters:
    ///   - urlConversion: URL 포맷
    ///   - params: 파라미터
    ///   - method: 메소드
    ///   - tracking: 로그 Tracker
    /// - Returns: Starlink
    public func request(
        _ urlConversion: URLConversion,
        params: SafeDictionary<String, Any>?,
        method: Starlink.Method,
        headers: [Starlink.Header] = [],
        encoding: (any StarlinkEncodable) = StarlinkURLEncoding(),
        uploadForm: UploadDataForm? = nil
    ) -> StarlinkRequest {
        let request = Starlink.Request(
            session: session,
            path: urlConversion,
            params: params,
            uploadForm: uploadForm,
            method: method,
            headers: headers,
            trakers: trackers,
            interceptors: interceptors,
            encoding: encoding
        )
        return request
    }
    
    /// Starlink.Request ( URL Session을 요청하는 Request 생성 )
    /// - Parameters:
    ///   - urlConversion: URL 포맷
    ///   - params: Encodable
    ///   - method: 메소드
    ///   - tracking: 로그 Tracker
    /// - Returns: Starlink
    public func request(
        _ urlConversion: URLConversion,
        encodable: Encodable?,
        method: Starlink.Method,
        headers: [Starlink.Header] = [],
        encoding: (any StarlinkEncodable) = StarlinkURLEncoding(),
        uploadForm: UploadDataForm? = nil
    ) -> StarlinkRequest {
        var safeParams: SafeDictionary<String, Any>? = nil
        if let params = encodable {
            safeParams = SafeDictionary(encodable: params)
        }
        let request = Starlink.Request(
            session: session,
            path: urlConversion,
            params: safeParams,
            uploadForm: uploadForm,
            method: method,
            headers: headers,
            trakers: trackers,
            interceptors: interceptors,
            encoding: encoding
        )
        return request
    }
}

public struct UploadDataForm {
    let name: String
    let fileName: String
    let mimeType: String
    let data: Data
    
    public init(name: String, fileName: String, data: Data, mimeType: String) {
        self.name = name
        self.fileName = fileName
        self.data = data
        self.mimeType = mimeType
    }
}

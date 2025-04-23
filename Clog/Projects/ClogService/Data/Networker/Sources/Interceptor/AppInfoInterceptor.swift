//
//  AppInfoInterceptor.swift
//  Networker
//
//  Created by saeng lin on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Starlink

public final class AppInfoInterceptor: StarlinkInterceptor, Sendable {
    
    public func adapt(
        _ urlRequest: inout URLRequest
    ) async throws -> URLRequest {
        
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
        let buildVersion = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""

        let currentTimeZone = TimeZone.current.identifier

        urlRequest.setHeader(.init(name: "APP_VERSION", value: version))
        urlRequest.setHeader(.init(name: "APP_BUILD", value: buildVersion))
        urlRequest.setHeader(.init(name: "TIME_ZONE", value: currentTimeZone))
        if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleDisplayName") as? String {
            urlRequest.setHeader(.init(name: "APP_NAME", value: appName))
        } else if let appName = Bundle.main.object(forInfoDictionaryKey: "CFBundleName") as? String {
            urlRequest.setHeader(.init(name: "APP_NAME", value: appName))
        }
        
        return urlRequest
    }
    
    public func retry(
        _ urlRequest: inout URLRequest,
        response: Starlink.Response
    ) async throws -> (URLRequest, StartlinkRetryType) {
        return (urlRequest, .doNotRetry)
    }
}

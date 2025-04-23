//
//  LogTrackering.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

public protocol StarlinkTracking: Sendable {
    func didRequest(_ request: Starlink.Request, urlRequest: URLRequest)
    func willRequest(_ request: Starlink.Request, _ response: Starlink.Response)
}

public struct StarlinkLogTraking: StarlinkTracking {
    
    public init() {}
    
    /// 로그 요청
    /// - Parameter request: 요청 정보
    public func didRequest(_ request: Starlink.Request, urlRequest: URLRequest) {
        #if DEBUG
        var log: String = ""
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let formattedDate = formatter.string(from: request.requestTime)

        log += "👉 [\(request.path)]\n[요청시간] \(formattedDate)"

        // 📄 Header
        var headerLog = "\n📄 Header\n{"
        urlRequest.allHTTPHeaderFields?.forEach({ key, value in
            headerLog += "\n    \(key): \(value),"
        })
        headerLog += "\n}"
        log += headerLog

        // 📄 Params
        var paramsLog = "\n📄 Params\n{"
        request.params?.forEach({ key, value in
            paramsLog += "\n    \(key): \(value),"
        })
        paramsLog += "\n}"
        log += paramsLog

        // 📄 Body
        if let httpBody = urlRequest.httpBody,
           let contentType = urlRequest.value(forHTTPHeaderField: "Content-Type") {

            log += "\n📄 Body (\(contentType)):\n"

            if contentType.contains("application/json"),
               let jsonObject = try? JSONSerialization.jsonObject(with: httpBody, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                log += jsonString
            } else if let stringBody = String(data: httpBody, encoding: .utf8) {
                log += stringBody
            } else {
                log += "(binary body)"
            }
        } else {
            log += "\n📄 Body: 없음"
        }

        print(log)
        #endif
    }

    /// 로그 응답
    /// - Parameters:
    ///   - request: 요청 정보
    ///   - response: 응답 정보
    public func willRequest(_ request: Starlink.Request, _ response: Starlink.Response) {
        #if DEBUG
        var log: String = ""
        let statusCode = (response.response as? HTTPURLResponse)?.statusCode ?? -999
        switch statusCode {
        case 200 ..< 300:
            log += "🟢"
        default:
            log += "🔴"
        }

        log += "[\(statusCode)]"

        let timeInterval = response.responseTime.timeIntervalSince(request.requestTime)
        let milliseconds = String(format: "%.2fms", timeInterval * 1000)

        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        let formattedDate = formatter.string(from: response.responseTime)

        log += "[\(request.path)]\n[응답시간][\(milliseconds)] \(formattedDate)"

        if let data = response.data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
               let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
               let jsonString = String(data: jsonData, encoding: .utf8) {
                log += "\n📄 Response Data:\n\(jsonString)"
            }
        } else if let error = response.error {
            log += "\n📄 Response ERROR:\n\(error)"
        }

        print(log)
        #endif
    }
    
    
}

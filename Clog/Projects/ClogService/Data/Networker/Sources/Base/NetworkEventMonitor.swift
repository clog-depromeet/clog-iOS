//
//  NetworkEventMonitor.swift
//  Networker
//
//  Created by Junyoung on 4/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Alamofire

final class NetworkEventMonitor: EventMonitor {
    let queue = DispatchQueue(label: "NetworkEventMonitor")
    private var requestLogs: [String: String] = [:]
    
    // MARK: Request
    func requestDidFinish(_ request: Request) {
        #if Dev
        let logString: String = """
        ----------------------------------------------------
        🛰 NETWORK Reqeust LOG
        ----------------------------------------------------
        1️⃣ URL / Method / Header

        🟢 URL: \(request.request?.url?.absoluteString ?? "")
        🟢 Method: \(request.request?.httpMethod ?? "")
        🟢 Headers: \(request.request?.allHTTPHeaderFields?.toPrettyPrintedString ?? "")
        ----------------------------------------------------
        2️⃣ Body

        \(request.request?.httpBody?.toPrettyPrintedString ?? "보낸 Body가 없습니다.")
        ----------------------------------------------------
        """
        
        requestLogs[request.id.uuidString] = logString
        #endif
    }
    
    // MARK: Response
    func request(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Data?, AFError>
    ) {
        #if Dev
        var logString = requestLogs[request.id.uuidString] ?? ""
        
        logString += "\n🛰 NETWORK Response LOG"
        logString += "\n----------------------------------------------------\n\n"

        switch response.result {
        case .success(_):
            logString += "🟢 서버 연결 성공"
        case .failure(_):
            logString += "🔴 서버 연결 실패"
        }

        logString += "\n\nResult: \(response.result)" + "\n"
        + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
        
        logString += "\n----------------------------------------------------\n\n"
        logString += "3️⃣ Data 확인하기\n"
        if let response = response.data?.toPrettyPrintedString {
            logString += response
        } else {
            logString += "❗데이터가 없거나, Encoding에 실패했습니다.\n"
        }
        logString += "\n\n----------------------------------------------------"
        print(logString)
        requestLogs.removeValue(forKey: request.id.uuidString)
        #endif
    }
    
    func request(
        _ request: Request,
        didFailTask task: URLSessionTask,
        earlyWithError error: AFError
    ) {
        print("URLSessionTask가 Fail 했습니다.")
    }

    func request(
        _ request: Request,
        didFailToCreateURLRequestWithError error: AFError
    ) {
        print("URLRequest를 만들지 못했습니다.")
    }

    func requestDidCancel(
        _ request: Request
    ) {
        print("request가 cancel 되었습니다")
    }
}

extension Data {
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
              ) else { return nil }
        return prettyPrintedString as String
    }
}

extension Dictionary {
    var toPrettyPrintedString: String? {
        guard let data = try? JSONSerialization.data(withJSONObject: self, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(
                data: data,
                encoding: String.Encoding.utf8.rawValue
              ) else { return nil }
        return prettyPrintedString as String
    }
}

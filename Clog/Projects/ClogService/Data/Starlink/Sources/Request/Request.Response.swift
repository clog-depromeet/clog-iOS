//
//  Requests.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation
import Combine

import Alamofire
import Pulse
import PulseProxy
import PulseUI

extension Starlink.Request {
    
    private func perform(retryURLRequest: URLRequest? = nil) async throws -> (Data, URLResponse) {

        guard let urlConversion = try? path.asURL() else {
            throw StarlinkError.inValidURLPath(ErrorInfo(code: "-999", error: nil, message: nil))
        }
        
        var urlRequest = retryURLRequest ?? URLRequest(url: urlConversion)
        urlRequest.httpMethod = "\(method)"
        
        if let parameters = params?.toDictionary() {
            try urlRequest = encoding.encode(&urlRequest, with: parameters)
        }
        
        for interceptor in self.interceptors where retryURLRequest == nil {
            urlRequest = try await interceptor.adapt(&urlRequest)
        }
        
        urlRequest.setHeaders(headers)
        
        self.trakers.allTrackers().forEach { $0.didRequest(self, urlRequest: urlRequest) }
        
        do {
            let (data, response) = try await session.data(for: urlRequest, delegate: nil)
            return (data, response)
        } catch {
            
            let response = Starlink.Response(response: nil, data: nil, error: error)
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }
            
            // retry Count가 최대 retry 갯수보다 낮으면 retry
            guard self.retryCount < self.retryLimit else {
                throw await Starlink.sessionErrorHandler(error)
            }
            
            // default는 다시 요청 하지 않음
            var retryResult: StartlinkRetryType = .doNotRetry
            
            self.retryCount += 1
            
            for interceptor in self.interceptors {
                let (retryURLRequest, retryType)  = try await interceptor.retry(&urlRequest, response: response)
                urlRequest = retryURLRequest
                retryResult = retryType
            }
            
            switch retryResult {
            case .retry:
                // 재요청 이면 요청
                return try await perform(retryURLRequest: urlRequest)

            case .doNotRetry:
                // retry를 하지 않으면 throw error
                throw error
            }
        }
    }
}

extension Starlink.Request: StarlinkRequest {
    
    public func reponsePublisher<T: Decodable>() -> AnyPublisher<T, any Error> {
        return Future<T, Error> { @Sendable [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let model: T = try await self.reponseAsync()
                    promise(.success(model))
                    
                } catch {
                    promise(.failure(error))
                }
            }
        }.eraseToAnyPublisher()
    }
    
    public func reponseAsync<T: Decodable>() async throws -> T {
        do {
            let (data, urlResponse) = try await self.perform()
            let response = Starlink.Response(response: urlResponse, data: data, error: nil)
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }
            let model: T = try self.validResponse(response)
            return model
        } catch {
            throw await Starlink.sessionErrorHandler(error)
        }
        
    }
    
    public func response<T: Decodable>(_ complete: @escaping @Sendable (Result<T, any Error>) -> Void) {
        Task { [weak self] in
            guard let self else { return }
            do {
                let model: T = try await reponseAsync()
                complete(.success(model))
            } catch {
                complete(.failure(error))
            }
        }
    }
    
    public func uploadResponse<T>(retryURLRequest: URLRequest? = nil) async throws -> T where T : Decodable {
        guard let uploadForm = self.uploadForm else {
            throw StarlinkError.inValidParams(.init(
                code: "-999",
                error: nil,
                message: .init(code: nil, message: "Upload form is missing", detail: nil, name: nil)))
        }
        
        guard let urlConversion = try? path.asURL() else {
            throw StarlinkError.inValidURLPath(ErrorInfo(code: "-999", error: nil, message: nil))
        }
        
        var urlRequest = URLRequest(url: urlConversion)
        urlRequest.timeoutInterval = 300
        urlRequest.httpMethod = "POST"

        for interceptor in self.interceptors {
            urlRequest = try await interceptor.adapt(&urlRequest)
        }

        if let parameters = params?.toDictionary() {
            try urlRequest = encoding.encode(&urlRequest, with: parameters)
        }
        
        let boundary = UUID().uuidString
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        for interceptor in self.interceptors where retryURLRequest == nil {
            urlRequest = try await interceptor.adapt(&urlRequest)
        }

        var alamofireHeaders = urlRequest.allHTTPHeaderFields?.map { key, value in
            HTTPHeader(name: key, value: value)
        } ?? .init()

        let headers = headers.map { header in
            HTTPHeader(name: header.name, value: header.value)
        }

        alamofireHeaders.append(contentsOf: headers)

        do {
            let (data, response) = try await self.upload(urlRequest: urlRequest, uploadForm: uploadForm, header: alamofireHeaders)
            let model: T = try self.alamofileValidReponse(response, data: data)
            return model
        } catch {
            let response = Starlink.Response(response: nil, data: nil, error: error)
            self.trakers.allTrackers().forEach { $0.willRequest(self, response) }

            // retry Count가 최대 retry 갯수보다 낮으면 retry
            guard self.retryCount < self.retryLimit else {
                throw await Starlink.sessionErrorHandler(error)
            }

            // default는 다시 요청 하지 않음
            var retryResult: StartlinkRetryType = .doNotRetry

            self.retryCount += 1

            for interceptor in self.interceptors {
                let (retryURLRequest, retryType)  = try await interceptor.retry(&urlRequest, response: response)
                urlRequest = retryURLRequest
                retryResult = retryType
            }

            switch retryResult {
            case .retry:
                // 재요청 이면 요청
                return try await uploadResponse(retryURLRequest: urlRequest)

            case .doNotRetry:
                // retry를 하지 않으면 throw error
                throw await Starlink.sessionErrorHandler(error)
            }
        }
    }
    
    private func upload(
        urlRequest: URLRequest,
        uploadForm: UploadDataForm,
        header: [HTTPHeader]
    ) async throws -> (Data?, HTTPURLResponse?) {
        return try await withCheckedThrowingContinuation { continuation in
            AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(uploadForm.data,
                                         withName: uploadForm.name,
                                         fileName: uploadForm.fileName,
                                         mimeType: uploadForm.mimeType)
                
                if let parameters = self.params?.toDictionary() {
                    for (key, value) in parameters {
                        if let valueString = value as? String, let valueData = valueString.data(using: .utf8) {
                            multipartFormData.append(valueData, withName: key)
                        }
                    }
                }
            },
                      to: urlRequest.url!,
                      method: .post,
                      headers: .init(header))
            .validate()
            .response { response in
                switch response.result {
                case .success(let data):
                    continuation.resume(with: .success((data, response.response)))
                    
                case .failure(let error):
                    continuation.resume(with: .failure(error as Error))
                }
            }
        }
    }
}

extension StarlinkRequest {
    
    func alamofileValidReponse<T: Decodable>(_ response: HTTPURLResponse?, data: Data?) throws -> T {
        // 200 응답 체크
        guard let response = response, (200 ..< 300).contains(response.statusCode) else {
            throw StarlinkError.inValidStatusCode(.init(code: "", error: nil, message: .init(code: nil, message: "Upload form is missing", detail: nil, name: nil)))
        }
        
        guard let data = data else {
            throw StarlinkError.nullPointData(.init(code: "", error: nil, message: .init(code: nil, message: "Upload form is missing", detail: nil, name: nil)))
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
            
        } catch {
            throw StarlinkError.inValidJSONData(.init(code: "", error: nil, message: .init(code: nil, message: "Upload form is missing", detail: nil, name: nil)))
        }
    }
    
    /// 유효성 체크 함수
    /// - Parameter response: 응답 response
    /// - Returns: 모델
    func validResponse<T: Decodable>(_ response: Starlink.Response) throws -> T {
        
        // 200 응답 체크
        guard let httpResponse = (response.response as? HTTPURLResponse), (200 ..< 300).contains(httpResponse.statusCode) else {
            throw StarlinkError.inValidStatusCode(errorInfo(response: response))
        }
        
        // data 언래핑
        guard let data = response.data else {
            throw StarlinkError.nullPointData(errorInfo(response: response))
        }
        
        do {
            let model = try JSONDecoder().decode(T.self, from: data)
            return model
            
        } catch {
            throw StarlinkError.inValidJSONData(errorInfo(response: response))
        }
    }
    
    private func errorInfo(response: Starlink.Response) -> ErrorInfo {
        var message: ErrorMessage? = nil
        if let data = response.data {
            if let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []), let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted), let errorMessage = try? JSONDecoder().decode(ErrorMessage.self, from: jsonData) {
                message = errorMessage
            }
        }
        return ErrorInfo(
            code: "\((response.response as? HTTPURLResponse)?.statusCode ?? -999)",
            error: response.error,
            message: message
        )
    }
}

extension Data {
    mutating func appendFormat(_ data: Data?) {
        if let data {
            self.append(data)
        }
    }
}
public enum PulseManager {
    public static func onPulse() {
        URLSessionProxyDelegate.enableAutomaticRegistration()
    }
}


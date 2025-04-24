//
//  Session.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

import Pulse

public protocol Sessionable: Sendable {
    func data(for request: URLRequest, delegate: (any URLSessionTaskDelegate)?) async throws -> (Data, URLResponse)
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
    func uploadTask(with request: URLRequest, from bodyData: Data?, completionHandler: @escaping @Sendable (Data?, URLResponse?, (any Error)?) -> Void) -> URLSessionUploadTask
}

extension URLSession: Sessionable {}
extension URLSessionProxy: Sessionable {}

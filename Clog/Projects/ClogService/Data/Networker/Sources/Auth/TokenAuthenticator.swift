//
//  TokenAuthenticator.swift
//  Networker
//
//  Created by Junyoung on 4/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//
import Foundation

import Alamofire

import TokenDomain

final class TokenAuthenticator: Authenticator {
    typealias Credential = TokenAuthenticationCredential
    
    func didRequest(
        _ urlRequest: URLRequest,
        with response: HTTPURLResponse,
        failDueToAuthenticationError error: any Error
    ) -> Bool {
        return response.statusCode == 401
    }
    
    func isRequest(
        _ urlRequest: URLRequest,
        authenticatedWith credential: TokenAuthenticationCredential
    ) -> Bool {
        return urlRequest.headers["Authorization"] == credential.accessToken
    }
    
    func apply(_ credential: TokenAuthenticationCredential, to urlRequest: inout URLRequest) {
        guard let accessToken = credential.accessToken else { return }
        urlRequest.headers.add(.authorization("Bearer \(accessToken)"))
    }
    
    func refresh(
        _ credential: TokenAuthenticationCredential,
        for session: Alamofire.Session,
        completion: @escaping (Result<TokenAuthenticationCredential, Error>) -> Void
    ) {
        guard let refreshToken = credential.refreshToken else {
            // 리프레시 토큰 없음
            completion(.failure(NetworkError.tokenEmpty))
            return
        }
        
        refreshAccessToken(refreshToken: refreshToken) { result in
            switch result {
            case .success(let success):
                completion(.success(success))
            case .failure(let failure):
                completion(.failure(failure))
            }
        }
    }
    
    private func refreshAccessToken(
        refreshToken: String,
        completion: @escaping (Result<Credential, Error>) -> Void
    )  {
        Task {
            do {
                // refresh 토큰을 사용해서 Access 재발급
                // 임시 코드
                let token = AuthToken(accessToken: "", refreshToken: "")
                
                let credential = Credential(token)
                
                completion(.success(credential))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

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
import Shared

final class TokenAuthenticator: Authenticator {
    typealias Credential = TokenAuthenticationCredential
    
    private var tokenRepository: TokenRepository {
        ClogDI.container.resolve(TokenRepository.self)!
    }
    
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
        urlRequest.headers.add(.authorization(accessToken))
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
                NotificationCenter.default.post(name: .didKickOut, object: nil)
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
                // refresh 재발급 및 저장
                let token = try await tokenRepository.refresh(refreshToken)
                tokenRepository.saveToken(token)
                completion(.success(Credential()))
            } catch {
                completion(.failure(error))
            }
        }
    }
}

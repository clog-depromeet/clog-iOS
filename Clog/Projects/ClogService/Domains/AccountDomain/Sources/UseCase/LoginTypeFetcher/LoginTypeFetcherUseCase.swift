//
//  LoginTypeFetcherUseCase.swift
//  AccountDomain
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Dependencies
import Shared

public enum LoginType: String {
    case kakao = "KAKAO"
    case apple = "APPLE"
    
    public init(_ value: String) {
        self = .init(rawValue: value) ?? .apple
    }
}

public protocol LoginTypeFetcherUseCase {
    func fetch() -> LoginType
    func clear() async
}

public struct LoginTypeFetcher: LoginTypeFetcherUseCase {
    public init(repository: LoginTokenRepository) {
        self.repository = repository
    }
    
    private let repository: LoginTokenRepository
    
    public func fetch() -> LoginType {
        repository.fetchLoginType()
    }

    public func clear() async {
        await repository.clearToken()
    }
}

public struct MockLoginTypeFetcher: LoginTypeFetcherUseCase {
    public func fetch() -> LoginType {
        return .kakao
    }

    public func clear() async {}
}

public enum LoginTypeFetcherDependencyKey: DependencyKey {
    public static var liveValue: any LoginTypeFetcherUseCase = ClogDI.container.resolve(LoginTypeFetcherUseCase.self)!
    
//    public static var testValue: any LoginTypeFetcherUseCase = MockLoginTypeFetcher()
    
//    public static var previewValue: any LoginTypeFetcherUseCase = MockLoginTypeFetcher()
}

public extension DependencyValues {
    var loginTypeFetcherUseCase: any LoginTypeFetcherUseCase {
        get { self[LoginTypeFetcherDependencyKey.self] }
        set { self[LoginTypeFetcherDependencyKey.self] = newValue }
    }
}

//
//  AppData.swift
//  Data
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import TokenDomain

enum AppData {
    
    
    /*
    /// 로그아웃 시 삭제할 데이터
    enum LoginUserUserDefaultKey: String, CaseIterable {
        
    }
    */
    
    /// 로그아웃을 해도, 삭제하지 않을 데이터
    enum UserDefaultKey: String, CaseIterable {
        case didCompleteOnboarding
        
        static var deletable: [UserDefaultKey] {
            return [.didCompleteOnboarding]
        }
        
        static var nonDeletable: [UserDefaultKey] {
            return []
        }
    }
    
    /// 로그아웃 시 삭제할 데이터
    enum LoginUserKeychainKey: String, CaseIterable {
        case token
        case provider
        
        var itemClass: KeychainItemType {
            switch self {
            case .token: .genericPassword
            case .provider: .genericPassword
            }
        }
    }
    
    /*
    /// 로그아웃을 해도, 삭제하지 않을 데이터
    enum KeychainKey: String, CaseIterable {
        
    }
    */
    
    @Keychain(
        key: LoginUserKeychainKey.token.rawValue,
        itemClass: LoginUserKeychainKey.token.itemClass
    )
    static var token: AuthToken?
    
    @Keychain(
        key: LoginUserKeychainKey.provider.rawValue,
        itemClass: LoginUserKeychainKey.provider.itemClass
    )
    static var provider: String?
    
    static func clearLocalData() {
        // TODO
        /*
        LoginUserUserDefaultKey.allCases.forEach {
            UserDefaults.standard.removeObject(forKey: $0.rawValue)
        }
         */
        
        LoginUserKeychainKey.allCases.forEach {
            try? KeychainManager.shared.deleteItem(ofClass: $0.itemClass, key: $0.rawValue)
        }
    }
}

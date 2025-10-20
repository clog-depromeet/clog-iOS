//
//  KeychainItemType.swift
//  Data
//
//  Created by soi on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

enum KeychainItemType: RawRepresentable, CaseIterable {
    typealias RawValue = CFString

    case genericPassword
    case internetPassword
    case certificate
    case cryptography
    case identity

    init?(rawValue: CFString) {
        switch rawValue {
        case kSecClassGenericPassword:
            self = .genericPassword
        case kSecClassInternetPassword:
            self = .internetPassword
        case kSecClassCertificate:
            self = .certificate
        case kSecClassKey:
            self = .cryptography
        case kSecClassIdentity:
            self = .identity
        default:
            return nil
        }
    }

    var rawValue: CFString {
        switch self {
        case .genericPassword:
            return kSecClassGenericPassword
        case .internetPassword:
            return kSecClassInternetPassword
        case .certificate:
            return kSecClassCertificate
        case .cryptography:
            return kSecClassKey
        case .identity:
            return kSecClassIdentity
        }
    }
}

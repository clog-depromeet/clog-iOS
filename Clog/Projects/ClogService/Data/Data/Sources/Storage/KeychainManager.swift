//
//  KeychainManager.swift
//  Data
//
//  Created by soi on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

final class KeychainManager {
    typealias KeychainDictionary = [String: Any]
    typealias ItemAttributes = [CFString : Any]
    
    static let shared = KeychainManager()
    private let encoder = JSONEncoder()
    private let decoder = JSONDecoder()
    private var attributes: ItemAttributes?
    
    private init() {}
    
    func saveItem<T: Encodable>(_ item: T, itemClass: KeychainItemType, key: String) throws {
        let itemData = try encoder.encode(item)
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
            kSecValueData as String: itemData as AnyObject
        ]
        
        if let itemAttributes = attributes {
            query = addAttributes(query: query, attributes: itemAttributes)
        }
        
        let result = SecItemAdd(query as CFDictionary, nil)
        if result != errSecSuccess {
            throw convertError(result)
        }
    }
    
    func retrieveItem<T: Decodable>(ofClass itemClass: KeychainItemType, key: String) throws -> T {
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        
        var item: CFTypeRef?
        
        if let itemAttributes = attributes {
            query = addAttributes(query: query, attributes: itemAttributes)
        }
        
        let result = SecItemCopyMatching(query as CFDictionary, &item)
        if result != errSecSuccess {
            throw convertError(result)
        }
        
        guard let keychainItem = item as? [String : Any],
              let data = keychainItem[kSecValueData as String] as? Data else {
            throw KeychainError.invalidData
        }
        
        return try decoder.decode(T.self, from: data)
    }
    
    func updateItem<T: Encodable>(with item: T, ofClass itemClass: KeychainItemType, key: String) throws {
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject,
        ]
        
        if let itemAttributes = attributes {
            query = addAttributes(query: query, attributes: itemAttributes)
        }
        
        let itemData = try encoder.encode(item)
        
        let attributesToUpdate: KeychainDictionary = [
            kSecValueData as String: itemData as AnyObject
        ]
        
        let result = SecItemUpdate(query as CFDictionary, attributesToUpdate as CFDictionary)
        if result != errSecSuccess {
            throw convertError(result)
        }
    }
    
    func deleteItem(ofClass itemClass: KeychainItemType, key: String) throws {
        var query: KeychainDictionary = [
            kSecClass as String: itemClass.rawValue,
            kSecAttrAccount as String: key as AnyObject
        ]
        
        if let itemAttributes = attributes {
            query = addAttributes(query: query, attributes: itemAttributes)
        }
        
        let result = SecItemDelete(query as CFDictionary)
        if result != errSecSuccess {
            throw convertError(result)
        }
    }
    
    private func addAttributes(query: KeychainDictionary, attributes: ItemAttributes) -> KeychainDictionary {
        var copiedQuery = query
        for(key, value) in attributes {
            copiedQuery[key as String] = value
        }
        return copiedQuery
    }
    
    private func convertError(_ error: OSStatus) -> KeychainError {
        switch error {
        case errSecItemNotFound:
            return .itemNotFound
        case errSecDataTooLarge:
            return .invalidData
        case errSecDuplicateItem:
            return .duplicateItem
        default:
            return .unexpected(error)
        }
    }
    
    private enum KeychainError: Error {
        case invalidData
        case itemNotFound
        case duplicateItem
        case unexpected(OSStatus)
    }
}

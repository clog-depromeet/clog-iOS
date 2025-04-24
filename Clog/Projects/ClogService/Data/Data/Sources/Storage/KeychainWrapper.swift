//
//  KeychainWrapper.swift
//  Data
//
//  Created by soi on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

@propertyWrapper
struct Keychain<T: Codable> {
     
    let key: String
    let itemClass: KeychainItemType
    let keychain = KeychainManager.shared
    
    private var currentValue: T?
    
    init(key: String, itemClass: KeychainItemType) {
        self.key = key
        self.itemClass = itemClass
    }
    
    public var wrappedValue: T? {
        get {
            return getItem()
        }
        
        set {
            if let newValue {
                getItem() != nil ? updateItem(newValue) : saveItem(newValue)
            } else {
                deleteItem()
            }
        }
    }
}

private extension Keychain {
    func getItem() -> T? {
        return try? keychain.retrieveItem(ofClass: itemClass, key: key)
    }
    
    func saveItem(_ item: T) {
        try? keychain.saveItem(item, itemClass: itemClass, key: key)
    }
    
    func updateItem(_ item: T) {
        try? keychain.updateItem(with: item, ofClass: itemClass, key: key)
    }
    
    func deleteItem() {
        try? keychain.deleteItem(ofClass: itemClass, key: key)
    }
}

//
//  SafeDictionary.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

extension Starlink {

    public final class SafeDictionary<Key: Hashable, Value> {
        private var storage: [Key: Value] = [:]
        private let lock = StarlinkRWLock()
        
        public init(storage: [Key: Value] = [:]) {
            self.storage = storage
        }
        
        public subscript(key: Key) -> Value? {
            get { lock.read { storage[key]}}
            set { lock.write { storage[key] = newValue } }
        }
        
        public func forEach(_ callback: (Key, Value) throws -> Void) rethrows {
            try lock.read { try storage.forEach(callback) }
        }
    }

}

extension Starlink.SafeDictionary where Key == String, Value: Any {
    
    public func toDictionary() -> [Key: Value] {
        return lock.read { storage }
    }
    
    public convenience init?(encodable: Encodable) {
        let encoder = JSONEncoder()
        guard let data = try? encoder.encode(encodable),
              let dict = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            return nil
        }
        guard let storage = dict as? [String: Value] else { return nil }
        self.init(storage: storage)
    }
}

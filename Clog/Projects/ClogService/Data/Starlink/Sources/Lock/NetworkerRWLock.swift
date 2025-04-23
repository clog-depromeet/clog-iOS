//
//  StarlinkRWLock.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

protocol StarlinkLock {
    func read<T>(_ callback: () throws -> T) rethrows -> T
    func write<T>(_ callback: () throws -> T) rethrows -> T
}

final class StarlinkRWLock: StarlinkLock {
    
    private var lock: pthread_rwlock_t = pthread_rwlock_t()
    
    deinit { pthread_rwlock_destroy(&lock) }
    
    init() { pthread_rwlock_init(&lock, nil) }
    
    func read<T>(_ callback: () throws -> T) rethrows -> T {
        defer { pthread_rwlock_unlock(&lock) }
        pthread_rwlock_rdlock(&lock)
        return try callback()
    }
    
    func write<T>(_ callback: () throws -> T) rethrows -> T {
        defer { pthread_rwlock_unlock(&lock) }
        pthread_rwlock_wrlock(&lock)
        return try callback()
    }
}

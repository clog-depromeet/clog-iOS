//
//  SafeTrackers.swift
//  Starlink
//
//  Created by saeng lin on 2/15/25.
//

import Foundation

extension Starlink {

    final class SafeTrackers: @unchecked Sendable {
        
        private let lock = StarlinkRWLock()
        private var trackers: [any StarlinkTracking] = []
        
        init() {}
        
        func append(_ newTrackers: [any StarlinkTracking]) {
            lock.write { trackers.append(contentsOf: newTrackers) }
        }
        
        func allTrackers() -> [any StarlinkTracking] {
            lock.read { trackers }
        }
    }
}

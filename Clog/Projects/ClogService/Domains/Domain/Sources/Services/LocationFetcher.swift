//
//  LocationFetcher.swift
//  Domain
//
//  Created by soi on 4/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import CoreLocation
import Dependencies
import Shared

public protocol LocationFetcher {
    func fetchCurrentLocation() async throws -> Location
}

enum LocationFetcherKey: DependencyKey {
    static let liveValue: LocationFetcher = ClogDI.container.resolve(LocationFetcher.self)!
}

extension DependencyValues {
    public var locationFetcher: LocationFetcher {
        get { self[LocationFetcherKey.self] }
        set { self[LocationFetcherKey.self] = newValue }
    }
}

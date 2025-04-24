//
//  DefaultNearByCragRepository.swift
//  Data
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Domain
import Shared

public actor DefaultNearByCragRepository: NearByCragRepository {
    
    private var cursor: Double?
    private var keyword: String?
    private var hasMore: Bool = true
    private var latitude: Double?
    private var longitude: Double?
    private let dataSource: CragDataSource
    
    public init(dataSource: CragDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch(longitude: Double?, latitude: Double?, keyword: String?) async throws -> [Crag] {
        self.cursor = nil
        self.keyword = keyword
        self.hasMore = true
        if let longitude, let latitude {
            self.latitude = latitude
            self.longitude = longitude
        }
        
        return try await fetchMore()
    }
    
    public func fetchMore() async throws -> [Crag] {
        guard hasMore else { return [] }
        
        let (crags, meta) = try await dataSource.nearByCrags(longitude: longitude, latitude: latitude, cursor: cursor, keyword: keyword)
        
        self.cursor = meta?.nextCursor ?? 0
        self.hasMore = meta?.hasMore ?? false
        
        return crags.map { $0.toDomain() }
    }
}

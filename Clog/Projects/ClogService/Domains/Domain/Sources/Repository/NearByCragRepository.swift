//
//  NearByCragRepository.swift
//  Domain
//
//  Created by soi on 3/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol NearByCragRepository {
    func fetch(longitude: Double?, latitude: Double?, keyword: String?) async throws -> [Crag]
    func fetchMore() async throws -> [Crag]
}

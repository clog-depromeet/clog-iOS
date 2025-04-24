//
//  ReportRepository.swift
//  ReportDomain
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public protocol ReportRepository {
    func fetch() async throws -> Report
}

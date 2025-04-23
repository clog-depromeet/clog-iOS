//
//  DefaultReportRepository.swift
//  Data
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ReportDomain

public struct DefaultReportRepository: ReportRepository {
    private let dataSource: ReportDataSource
    
    public init(dataSource: ReportDataSource) {
        self.dataSource = dataSource
    }
    
    public func fetch() async throws -> Report {
        try await dataSource.report().toDomain()
    }
}

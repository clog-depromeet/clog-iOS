//
//  DefaultGradeRepository.swift
//  Data
//
//  Created by soi on 3/17/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

public struct DefaultGradeRepository: GradeRepository {
    private let dataSource: GradeDataSource
    
    public init(dataSource: GradeDataSource) {
        self.dataSource = dataSource
    }
    
    public func getGrades() async throws -> [Grade] {
        try await dataSource.myGrades().map { $0.toDomain() }
    }
    
    public func getCragGrades(cragId: Int) async throws -> [Grade] {
        try await dataSource.cragGrades(cragId: cragId).map { $0.toDomain() }
    }
}

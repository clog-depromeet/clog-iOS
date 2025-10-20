//
//  GradeUseCase.swift
//  Domain
//
//  Created by soi on 3/25/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import FolderDomain
import Shared

import Dependencies

public protocol GradeUseCase {
    func getCragGrades(cragId: Int) async throws -> [Grade]
}

enum GradeUseCaseKey: DependencyKey {
    static let liveValue: GradeUseCase = ClogDI.container.resolve(GradeUseCase.self)!
}

extension DependencyValues {
    public var gradeUseCase: GradeUseCase {
        get { self[GradeUseCaseKey.self] }
        set { self[GradeUseCaseKey.self] = newValue }
    }
}

public struct DefaultGradeUseCase: GradeUseCase {
    public let gradeRepository: GradeRepository
    
    public init(gradeRepository: GradeRepository) {
        self.gradeRepository = gradeRepository
    }
    
    public func getCragGrades(cragId: Int) async throws -> [Grade] {
        try await gradeRepository.getCragGrades(cragId: cragId)
    }
}

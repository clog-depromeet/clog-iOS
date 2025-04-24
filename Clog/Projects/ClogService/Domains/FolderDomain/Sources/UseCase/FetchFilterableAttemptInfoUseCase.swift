//
//  FetchFilterableAttemptInfoUseCase.swift
//  FolderDomain
//
//  Created by soi on 3/20/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

import ComposableArchitecture

public protocol FetchFilterableAttemptInfoUseCase {
    func execute() async throws -> FilterableAttemptInfo
}

enum FetchFilterableAttemptInfoUseCaseKey: DependencyKey {
    static let liveValue: FetchFilterableAttemptInfoUseCase = ClogDI.container.resolve(FetchFilterableAttemptInfoUseCase.self)!
}

extension DependencyValues {
    public var fetchFilterableAttemptInfoUseCase: FetchFilterableAttemptInfoUseCase {
        get { self[FetchFilterableAttemptInfoUseCaseKey.self] }
        set { self[FetchFilterableAttemptInfoUseCaseKey.self] = newValue }
    }
}

public struct DefaultFetchFilterableAttemptInfoUseCase: FetchFilterableAttemptInfoUseCase {
    private let gradeRepository: GradeRepository
    private let cragRepository: CragRepository
    
    public init(gradeRepository: GradeRepository, cragRepository: CragRepository) {
        self.gradeRepository = gradeRepository
        self.cragRepository = cragRepository
    }
    
    public func execute() async throws -> FilterableAttemptInfo {
        async let requestGrades = gradeRepository.getGrades()
        async let requestCrags = cragRepository.getMyCrags()
        
        do {
            let (crags, grades) = try await (requestCrags, requestGrades)
            let info = FilterableAttemptInfo(crags: crags, grades: grades)
            return info
        } catch {
            throw error
        }
    }
}

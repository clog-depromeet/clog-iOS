//
//  GradeRepository.swift
//  FolderDomain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol GradeRepository {
    func getGrades() async throws -> [Grade]
    func getCragGrades(cragId: Int) async throws -> [Grade]
}

// TODO: remove
public struct MockGradeRepository: GradeRepository {
    public init() {}
    
    public func getCragGrades(cragId: Int) async throws -> [Grade] {
        []
    }
    public func getGrades() async throws -> [Grade] {
        return [
            Grade(id: 0, name: "핑크", hexCode: "0xFF66B2"),
            Grade(id: 1, name: "레드", hexCode: "0xFF3B3F"),
            Grade(id: 2, name: "주황", hexCode: "0xFF5722"),
            Grade(id: 3, name: "노랑", hexCode: "0xFFEA00"),
            Grade(id: 4, name: "초록", hexCode: "0x4CAF50"),
            Grade(id: 5, name: "파랑", hexCode: "0x5E7CFF"),
            Grade(id: 6, name: "남색", hexCode: "0x3F51B5"),
            Grade(id: 7, name: "보라", hexCode: "0x9C27B0"),
            Grade(id: 8, name: "갈색", hexCode: "0x795548"),
            Grade(id: 9, name: "검정", hexCode: "0x000000"),
            Grade(id: 10, name: "회색", hexCode: "0x9E9E9E"),
            Grade(id: 11, name: "하양", hexCode: "0xFFFFFF")
        ]
    }
}

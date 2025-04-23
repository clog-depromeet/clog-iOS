//
//  CragRepository.swift
//  FolderDomain
//
//  Created by soi on 3/11/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Shared

public protocol CragRepository {
    func getMyCrags() async throws -> [Crag]
}

// TODO: remove
public struct MockCragRepository: CragRepository {
    public init() {}
    
    public func getMyCrags() async throws -> [Crag] {
        [
            Crag(id: 0, name: "클라이밍파크 강남점", address: "강남"),
            Crag(id: 0, name: "그립픽클라이밍짐", address: "강남"),
            Crag(id: 0, name: "더클라임 양재점", address: "양재"),
            Crag(id: 0, name: "클라이밍파크 신촌점", address: "신촌"),
            Crag(id: 0, name: "클라이밍팩토리", address: "홍대"),
            Crag(id: 0, name: "로프클라이밍센터", address: "강남"),
            Crag(id: 0, name: "그립픽클라이밍짐", address: "목동"),
            Crag(id: 0, name: "피크클라이밍센터", address: "서울"),
            Crag(id: 0, name: "클라이밍파크 강남점", address: "강남"),
            Crag(id: 0, name: "로카클라이밍짐", address: "이태원"),
            Crag(id: 0, name: "더클라임 양재점", address: "양재"),
            Crag(id: 0, name: "그립픽클라이밍짐", address: "서울"),
            Crag(id: 0, name: "클라이밍파크 종로점", address: "종로"),
            Crag(id: 0, name: "백운클라이밍센터", address: "강북"),
            Crag(id: 0, name: "락클라이밍센터", address: "강남"),
            Crag(id: 0, name: "미드클라이밍짐", address: "청담")
        ]
    }
}

//
//  Encodable+.swift
//  Networker
//
//  Created by Junyoung on 4/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import Moya

public extension Encodable {
    /// Encodable 객체를 Query Parameter로 변환하여 Task를 생성합니다.
    /// 변환에 실패하면 `.requestPlain`을 반환합니다.
    ///
    /// - Returns: `.requestParameters` 또는 `.requestPlain`
    func toSafeRequestParameter() -> Task {
        if let dict = try? self.toDictionary() {
            return .requestParameters(
                parameters: dict,
                encoding: URLEncoding.default
            )
        } else {
            return .requestPlain
        }
    }
    
    /// Encodable 객체를 [String: Any] 변환합니다.
    /// Any(value)가 nil인 경우 compactMapValues에서 제외됩니다.
    ///
    /// - Returns: `.requestParameters` 또는 `.requestPlain`
    private func toDictionary() throws -> [String: Any] {
        let encoder = JSONEncoder()

        let data = try encoder.encode(self)
        
        let object = try JSONSerialization.jsonObject(with: data, options: [])
        
        guard let dictionary = object as? [String: Any] else {
            throw NetworkError.decoding
        }
        
        return dictionary.compactMapValues{ $0 }
    }
}

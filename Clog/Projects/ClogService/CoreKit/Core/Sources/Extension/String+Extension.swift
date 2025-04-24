//
//  String+Extension.swift
//  Core
//
//  Created by soi on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

public extension String {
    /// 단어가 주어진 패턴과 일치하는지 확인 (초성 검색 포함)
    func matchesPattern(_ pattern: String) -> Bool {
        return ConsonantSearcherHelper.isMatchPattern(word: self, pattern: pattern)
    }
    
    /// 초성만 추출 -
    var consonants: String {
        return ConsonantSearcherHelper.extractConsonants(self)
    }
}

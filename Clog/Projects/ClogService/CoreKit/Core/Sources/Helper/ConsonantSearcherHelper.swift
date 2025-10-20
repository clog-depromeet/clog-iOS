//
//  ConsonantSearcherHelper.swift
//  Core
//
//  Created by soi on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

/// 한글 초성 검색을 위한 유틸리티 클래스
public enum ConsonantSearcherHelper {
    /// 한글 초성 목록
    private static let hangulConsonants = [
        "ㄱ", "ㄲ", "ㄴ", "ㄷ", "ㄸ", "ㄹ", "ㅁ", "ㅂ", "ㅃ", "ㅅ",
        "ㅆ", "ㅇ", "ㅈ", "ㅉ", "ㅊ", "ㅋ", "ㅌ", "ㅍ", "ㅎ"
    ]
    
    /**
     * word 내부에 패턴과 매칭되는 부분이 있는지 확인
     * 초성 검색 가능
     * 대소문자 무시
     */
    public static func isMatchPattern(word: String, pattern: String) -> Bool {
        let lowercasedWord = word.lowercased()
        let lowercasedPattern = pattern.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)
        let wordConsonants = extractConsonants(lowercasedWord)
        let patternConsonants = extractConsonants(lowercasedPattern)
        
        // 초성 매칭 확인
        guard let startIndex = findMatchingStartIndex(wordConsonants: wordConsonants, patternConsonants: patternConsonants) else {
            return false
        }
        
        // 초성 아닌 부분 추출
        let nonConsonantSegments = extractNonConsonantSegments(pattern: lowercasedPattern)
        
        // 매칭된 초성 위치에서 초성 아닌 부분의 경우 정확히 매칭되는지 확인
        return validateNonConsonantSegments(word: lowercasedWord, nonConsonantSegments: nonConsonantSegments, startIndex: startIndex)
    }
    
    /**
     * 초성을 추출하여 문자열로 반환합니다.
     */
    static func extractConsonants(_ word: String) -> String {
        var consonants = ""
        
        for char in word {
            if let unicodeScalar = char.unicodeScalars.first {
                let code = unicodeScalar.value
                
                if code >= 0xAC00 && code <= 0xD7A3 {
                    let initialIndex = Int((code - 0xAC00) / 588)
                    consonants.append(hangulConsonants[initialIndex])
                } else {
                    consonants.append(char)
                }
            }
        }
        
        return consonants
    }
    
    /**
     * pattern의 초성과 word의 초성 비교
     * 일치하는 곳이 없다면 nil 리턴
     * 패턴이 존재하는 위치의 시작 인덱스 리턴
     */
    private static func findMatchingStartIndex(wordConsonants: String, patternConsonants: String) -> Int? {
        let patternLength = patternConsonants.count
        let maxStartIndex = wordConsonants.count - patternLength
        
        guard maxStartIndex >= 0 else { return nil }
        
        for i in 0...maxStartIndex {
            let startIndex = wordConsonants.index(wordConsonants.startIndex, offsetBy: i)
            let endIndex = wordConsonants.index(startIndex, offsetBy: patternLength)
            
            if wordConsonants[startIndex..<endIndex] == patternConsonants {
                return i
            }
        }
        
        return nil
    }
    
    /**
     * pattern에서 초성이 아닌 부분을 추출하여 배열로 반환
     */
    private static func extractNonConsonantSegments(pattern: String) -> [String] {
        var segments = [String]()
        var segmentBuffer = ""
        
        for char in pattern {
            if let unicodeScalar = char.unicodeScalars.first {
                if isConsonant(unicodeScalar.value) {
                    if !segmentBuffer.isEmpty {
                        segments.append(segmentBuffer)
                        segmentBuffer = ""
                    }
                } else {
                    segmentBuffer.append(char)
                }
            }
        }
        
        if !segmentBuffer.isEmpty {
            segments.append(segmentBuffer)
        }
        
        return segments
    }
    
    private static func isConsonant(_ code: UInt32) -> Bool {
        return (code >= 0x1100 && code <= 0x1112) || (code >= 0x3131 && code <= 0x314E)
    }
    
    /**
     * 주어진 단어가 초성이 아닌 부분을 포함하는지 검증
     * 초성이 아닌 경우는 값이 정확히 일치해야함
     * ex) ㄷㅈㅇ실 -> "실"은 word의 4번째에 포함되어야함.
     */
    private static func validateNonConsonantSegments(word: String, nonConsonantSegments: [String], startIndex: Int) -> Bool {
        var currentIndex = startIndex
        
        // 각 초성이 아닌 segment 조회
        for segment in nonConsonantSegments {
            if let range = word.range(of: segment, range: word.index(word.startIndex, offsetBy: currentIndex)..<word.endIndex) {
                let matchIndex = word.distance(from: word.startIndex, to: range.lowerBound)
                currentIndex = matchIndex + segment.count
            } else {
                return false
            }
        }
        
        return true
    }
}

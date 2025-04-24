//
//  VideoDataManager.swift
//  VideoFeatureInterface
//
//  Created by Junyoung on 4/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import VideoDomain
import Dependencies
import Shared

public protocol VideoDataManager {
    /// 저장된 스토리를 가져오는 함수
    func getSavedStory() -> SavedStory?
    
    /// 저장된 난이도를 가져오는 함수
    func getSavedGrade() -> SavedGrade?
    
    /// 스토리 저장
    func saveStory(_ story: SavedStory?)
    
    /// 난이도 저장
    func saveGrade(_ grade: SavedGrade?)
    
    /// 암장 ID 저장
    func saveCragId(_ id: Int)
    
    /// 시도 카운트 증가
    func incrementCount()
    
    /// 시도 카운트 감소
    func decrementCount()
    
    /// 시도 카운트
    func getCount() -> Int
    
    /// 문제 id 변경
    func changeProblemId(_ id: Int)
    
    /// 첫 시도인지 확인
    func isFirstAttempt() -> Bool
    
    /// 비디오 저장 데이터 삭제
    func clear()
    
    /// 암장 Id 조회
    func getCragId() -> Int?
    
    func getIsRecordTooltipOn() -> Bool
    func setIsRecordTooltipOn(_ isOn: Bool)
    
    func getIsEditTooltipOn() -> Bool
    func setIsEditTooltipOn(_ isOn: Bool)
    
    func getIsInitializedRecordTooltipState() -> Bool
    func setIsInitializedRecordTooltipState(_ isOn: Bool)
    
    func getIsInitializedEditTooltipState() -> Bool
    func setIsInitializedEditTooltipState(_ isOn: Bool)
}

enum VideoDataManagerDependencyKey: DependencyKey {
    static let liveValue: VideoDataManager = ClogDI.container.resolve(VideoDataManager.self)!
}

extension DependencyValues {
    public var videoDataManager: VideoDataManager {
        get { self[VideoDataManagerDependencyKey.self] }
        set { self[VideoDataManagerDependencyKey.self] = newValue }
    }
}

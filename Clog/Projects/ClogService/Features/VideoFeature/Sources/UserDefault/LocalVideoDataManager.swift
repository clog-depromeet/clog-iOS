//
//  UserDefault.swift
//  VideoFeature
//
//  Created by Junyoung on 3/26/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import VideoDomain

import VideoFeatureInterface

enum VideoDataKey {
    static let storyId = "storyId"
    static let problemId = "problemId"
    static let attemptCount = "attemptCount"
    static let cragId = "cragId"
    static let savedGrade = "savedGrade"
    static let isRecordTooltipOn = "isRecordTooltipOn"
    static let isEditTooltipOn = "isEditTooltipOn"
    static let isInitializedRecordTooltipState = "isInitializedRecordTooltipState"
    static let isInitializedEditTooltipState = "isInitializedEditTooltipState"
}

public final class LocalVideoDataManager: VideoDataManager {
    public init() {}
    
    public func getSavedStory() -> SavedStory? {
        guard let storyId = storyId, let problemId = problemId else {
            return nil
        }
        return SavedStory(storyId: storyId, problemId: problemId)
    }
    
    public func incrementCount() {
        attemptCount += 1
    }
    
    public func decrementCount() {
        attemptCount -= 1
    }
    
    public func getCount() -> Int {
        attemptCount
    }
    
    public func getSavedGrade() -> SavedGrade? {
        return savedGrade
    }
    
    public func changeProblemId(_ id: Int) {
        problemId = id
    }
    
    public func save(story: SavedStory?) {
        storyId = story?.storyId
        problemId = story?.problemId
    }
    
    public func isFirstAttempt() -> Bool {
        storyId == nil
    }
    
    public func saveStory(_ story: SavedStory?) {
        self.storyId = story?.storyId
        self.problemId = story?.problemId
    }
    
    public func saveGrade(_ grade: SavedGrade?) {
        savedGrade = grade
    }
    
    public func saveCragId(_ id: Int) {
        self.cragId = id
    }
    
    public func getCragId() -> Int? {
        self.cragId
    }
    
    public func clear() {
        savedGrade = nil
        cragId = nil
        storyId = nil
        problemId = nil
        attemptCount = 0
    }
    
    public func getIsRecordTooltipOn() -> Bool {
        isRecordTooltipOn
    }
    
    public func setIsRecordTooltipOn(_ isOn: Bool) {
        isRecordTooltipOn = isOn
    }
    
    public func getIsEditTooltipOn() -> Bool {
        isEditTooltipOn
    }
    
    public func setIsEditTooltipOn(_ isOn: Bool) {
        isEditTooltipOn = isOn
    }
    
    public func getIsInitializedRecordTooltipState() -> Bool {
        isInitializedRecordTooltipState
    }
    
    public func setIsInitializedRecordTooltipState(_ isOn: Bool) {
        isInitializedRecordTooltipState = isOn
    }
    
    public func getIsInitializedEditTooltipState() -> Bool {
        isInitializedEditTooltipState
    }
    
    public func setIsInitializedEditTooltipState(_ isOn: Bool) {
        isInitializedEditTooltipState = isOn
    }
}

extension LocalVideoDataManager {
    private var storyId: Int? {
        get {
            UserDefaults.standard.object(forKey: VideoDataKey.storyId) as? Int
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: VideoDataKey.storyId)
            } else {
                UserDefaults.standard.removeObject(forKey: VideoDataKey.storyId)
            }
        }
    }
    
    private var problemId: Int? {
        get {
            UserDefaults.standard.object(forKey: VideoDataKey.problemId) as? Int
        }
        set {
            if let newValue = newValue {
                UserDefaults.standard.set(newValue, forKey: VideoDataKey.problemId)
            } else {
                UserDefaults.standard.removeObject(forKey: VideoDataKey.problemId)
            }
        }
    }

    private var isInitializedRecordTooltipState: Bool {
        get {
            UserDefaults.standard.bool(forKey: VideoDataKey.isInitializedRecordTooltipState)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: VideoDataKey.isInitializedRecordTooltipState)
        }
    }
    
    private var isInitializedEditTooltipState: Bool {
        get {
            UserDefaults.standard.bool(forKey: VideoDataKey.isInitializedEditTooltipState)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: VideoDataKey.isInitializedEditTooltipState)
        }
    }
    
    private var isRecordTooltipOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: VideoDataKey.isRecordTooltipOn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: VideoDataKey.isRecordTooltipOn)
        }
    }
    
    private var isEditTooltipOn: Bool {
        get {
            UserDefaults.standard.bool(forKey: VideoDataKey.isEditTooltipOn)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: VideoDataKey.isEditTooltipOn)
        }
    }
    
    private var attemptCount: Int {
        get {
            UserDefaults.standard.integer(forKey: VideoDataKey.attemptCount)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: VideoDataKey.attemptCount)
        }
    }
    
    private var cragId: Int? {
        get {
            UserDefaults.standard.object(forKey: VideoDataKey.cragId) as? Int
        }
        set {
            if let newValue {
                UserDefaults.standard.set(newValue, forKey: VideoDataKey.cragId)
            } else {
                UserDefaults.standard.removeObject(forKey: VideoDataKey.cragId)
            }
        }
    }
    
    private var savedGrade: SavedGrade? {
        get {
            guard let data = UserDefaults.standard.data(forKey: VideoDataKey.savedGrade) else { return nil }
            return try? JSONDecoder().decode(SavedGrade.self, from: data)
        }
        set {
            if let newValue = newValue {
                if let encoded = try? JSONEncoder().encode(newValue) {
                    UserDefaults.standard.set(encoded, forKey: VideoDataKey.savedGrade)
                }
            } else {
                UserDefaults.standard.removeObject(forKey: VideoDataKey.savedGrade)
            }
        }
    }
}

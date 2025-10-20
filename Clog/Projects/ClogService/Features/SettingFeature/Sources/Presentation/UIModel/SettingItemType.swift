//
//  SettingItemType.swift
//  SettingFeature
//
//  Created by Junyoung on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import DesignKit
import SwiftUI

public enum SettingItemType: Equatable, Hashable {
    case privacyPolicy           // 개인정보 처리 방침
    case termsOfService          // 서비스 이용약관
    case feedback                // 의견 보내기
    case versionInfo(String)     // 버전정보
    case logout                  // 로그아웃
    case deleteAccount           // 탈퇴하기
    
    var title: String {
        switch self {
        case .privacyPolicy:
            return "개인정보 처리 방침"
        case .termsOfService:
            return "서비스 이용약관"
        case .feedback:
            return "의견 보내기"
        case .versionInfo:
            return "버전정보"
        case .logout:
            return "로그아웃"
        case .deleteAccount:
            return "탈퇴하기"
        }
    }
    
    // 화살표 이미지가 필요한지 여부
    var hasArrow: Bool {
        switch self {
        case .privacyPolicy, .termsOfService, .feedback:
            return true
        default:
            return false
        }
    }
    
    // 텍스트 컬러
    var textColor: Color {
        switch self {
        case .deleteAccount:
            return Color.clogUI.gray400
        default:
            return Color.clogUI.white
        }
    }
    
    // 버전 텍스트 값
    var versionText: String? {
        switch self {
        case .versionInfo(let version):
            return version
        default:
            return nil
        }
    }
    
    // 서비스 설정 아이템 배열
    static var serviceItems: [SettingItemType] {
        [
            .privacyPolicy,
            .termsOfService,
            // TODO: MVP 제외 추후 개발 예정
            .feedback,
            .versionInfo("v.\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "v.1.0.0")")
        ]
    }
    
    // 계정 관련 아이템 배열
    static var accountItems: [SettingItemType] {
        [
            .logout,
            .deleteAccount
        ]
    }
}

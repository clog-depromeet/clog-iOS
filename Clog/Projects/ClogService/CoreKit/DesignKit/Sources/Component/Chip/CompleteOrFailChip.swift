//
//  CompleteOrFailChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct CompleteOrFailChip: View {
    private let challengeResult: ChallengeResult
    private let isActive: Bool
    
    private var color: Color {
        if isActive {
            challengeResult == .complete ? Color.clogUI.complete : Color.clogUI.fail
        } else {
            Color.clogUI.gray600
        }
    }
    
    public init(challengeResult: ChallengeResult, isActive: Bool) {
        self.challengeResult = challengeResult
        self.isActive = isActive
    }
    
    public var body: some View {
        Text(challengeResult.name)
            .font(.h5)
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
            .foregroundStyle(isActive ? Color.clogUI.white : Color.clogUI.gray200)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(color)
            )
    }
}

#Preview {
    Group {
        CompleteOrFailChip(
            challengeResult: .complete,
            isActive: true
        )
        CompleteOrFailChip(
            challengeResult: .fail,
            isActive: true
        )
        CompleteOrFailChip(
            challengeResult: .complete,
            isActive: false
        )
        CompleteOrFailChip(
            challengeResult: .fail,
            isActive: false
        )
    }
}

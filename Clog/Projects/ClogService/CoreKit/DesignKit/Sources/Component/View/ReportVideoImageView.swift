//
//  ReportVideoImageView.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public enum ChallengeResult: CaseIterable {
    case complete
    case fail
    
    public var name: String {
        switch self {
        case .complete: "완등"
        case .fail: "실패"
        }
    }
}

public struct ReportVideoImageView: View {
    private let imageName: String
    private let challengeResult: ChallengeResult
    private let deleteButtonHandler: () -> Void
    
    private var borderColor: Color {
        challengeResult == .complete ? Color.clogUI.complete : Color.clogUI.fail
    }
    
    public init(imageName: String,
                challengeResult: ChallengeResult,
                deleteButtonHandler: @escaping () -> Void) {
        self.imageName = imageName
        self.challengeResult = challengeResult
        self.deleteButtonHandler = deleteButtonHandler
    }
    
    public var body: some View {
        ZStack(alignment: .topTrailing) {
            
            Thumbnail(url: imageName, width: 84, height: 84)
                .clipShape(RoundedRectangle(cornerRadius: 14.4))
                .overlay(
                    RoundedRectangle(cornerRadius: 14.4)
                        .strokeBorder(borderColor, lineWidth: 3)
                )
            
            Button {
                deleteButtonHandler()
            } label: {
                Image.clogUI.x
                    .offset(x: 4, y: -4)
            }
        }
    }
}

#Preview {
    Group {
        ReportVideoImageView(
            imageName: "clogLogo",
            challengeResult: .complete,
            deleteButtonHandler: { print("### 탭") })
        
        ReportVideoImageView(
            imageName: "clogLogo",
            challengeResult: .fail,
            deleteButtonHandler: { print("### 탭") })
    }
}

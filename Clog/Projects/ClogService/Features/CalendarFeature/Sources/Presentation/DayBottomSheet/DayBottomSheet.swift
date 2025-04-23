//
//  DayBottomSheet.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/13/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import CalendarDomain

struct DayBottomSheet: View {
    private let climbDay: CalendarDay
    private let onTapped: (Int) -> Void
    
    init(
        climbDay: CalendarDay,
        onTapped: @escaping (Int) -> Void
    ) {
        self.climbDay = climbDay
        self.onTapped = onTapped
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Text(climbDay.displayDate)
                    .font(.h3)
                    .foregroundStyle(Color.clogUI.white)
            }
            
            Spacer(minLength: 10)
            
            Rectangle()
                .fill(Color.clogUI.gray600)
                .frame(height: 1)
            
            Spacer(minLength: 16)
            
            VStack(alignment: .leading, spacing: 16) {
                ForEach(climbDay.groupedStories.keys.sorted(), id: \.self) { cragName in
                    Text(cragName.isEmpty ? "암장정보 미등록" : cragName)
                        .font(.b1)
                        .foregroundStyle(Color.clogUI.white)
                    
                    VStack(spacing: 8) {
                        ForEach(climbDay.groupedStories[cragName] ?? [], id: \.self) { story in
                            ClimbingCard(climbStory: story) { storyId in
                                onTapped(storyId)
                            }
                        }
                    }
                }
            }
        }
    }
}

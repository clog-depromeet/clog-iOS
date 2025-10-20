//
//  SelectGradeView.swift
//  DesignKit
//
//  Created by soi on 3/29/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct GridGradeView: View {
    private let grades: [DesignGrade]
    @Binding private var selectedGrade: DesignGrade?
    
    public init(grades: [DesignGrade], selectedGrade: Binding<DesignGrade?>) {
        self.grades = grades
        self._selectedGrade = selectedGrade
    }
    
    public var body: some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 36, maximum: 36), spacing: 28)], spacing: 18) {
            ForEach(grades, id: \.self) { grade in
                gradeGradeChip(for: grade)
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 16)
        .background(Color.clogUI.gray900)
        .cornerRadius(12)
    }
    
    private func gradeGradeChip(for grade: DesignGrade) -> some View {
        Circle()
            .foregroundStyle(grade.color)
            .overlay(
                Circle()
                    .strokeBorder(
                        selectedGrade == grade ? Color.clogUI.white : Color.clear,
                        lineWidth: 3
                    )
            )
            .onTapGesture {
                selectedGrade = grade
            }
    }
}

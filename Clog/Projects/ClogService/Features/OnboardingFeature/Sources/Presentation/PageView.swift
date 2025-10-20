//
//  PageView.swift
//  OnboardingFeature
//
//  Created by Junyoung on 3/23/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import DesignKit

enum PageType {
    case first
    case second
    case third
    
    var title: String {
        switch self {
        case .first:
            "클라이밍을 영상으로\n바로 촬영해요"
        case .second:
            "촬영한 영상을\n내 마음대로 편집해요"
        case .third:
            "나의 클라이밍 기록은\n리포트로 한눈에!"
        }
    }
    
    var image: Image {
        switch self {
        case .first:
            return Image.clogUI.onBoarding1
        case .second:
            return Image.clogUI.onBoarding2
        case .third:
            return Image.clogUI.onBoarding3
        }
    }
}

struct PageView: View {
    private let type: PageType
    
    init(type: PageType) {
        self.type = type
    }
    
    var body: some View {
        VStack(spacing: 18) {
            Spacer(minLength: 82)
            
            Text(type.title)
                .font(.h1)
                .foregroundStyle(Color.clogUI.white)
                .multilineTextAlignment(.center)
            
            type.image
                .resizable()
                .scaledToFit()
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PageView(type: .first)
}

//
//  VideoTimeChip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct VideoTimeChip: View {
    private let time: String
    
    public init(time: String) {
        self.time = time
    }
    
    public var body: some View {
        Text(time)
            .font(.h5)
            .frame(width: 73, height: 40)
            .foregroundStyle(Color.clogUI.white)
        .background(
            RoundedRectangle(cornerRadius: 99)
                .foregroundStyle(Color.clogUI.gray800.opacity(0.55))
        )
    }
}

#Preview {
    VideoTimeChip(time: "00:01:21")
}

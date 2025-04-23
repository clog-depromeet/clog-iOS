//
//  ToastView.swift
//  DesignKit
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

struct ToastView: View {
    private let message: String
    private let type: ToastType
    
    init(message: String, type: ToastType) {
        self.message = message
        self.type = type
    }
    
    var body: some View {
        HStack(spacing: 10) {
            switch type {
            case .success:
                Image.clogUI.check
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.primary)
            case .failure:
                Image.clogUI.alert
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.fail)
            case .none:
                EmptyView()
            }
            
            Text(message)
                .font(.b1)
                .foregroundStyle(Color.clogUI.white)
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 14)
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    ToastView(message: "실패시 나오는 토스트 메세지 입니다.", type: .failure)
    ToastView(message: "성공시 나오는 토스트 메세지 입니다.", type: .success)
    ToastView(message: "일반 토스트 메세지 입니다.", type: .none)
}

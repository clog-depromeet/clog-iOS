//
//  RecodingButton.swift
//  DesignKit
//
//  Created by Junyoung on 3/1/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct RecodingButton: View {
    @Environment(\.isEnabled) private var isEnabled: Bool
    @Binding private var isRecoding: Bool
    @Binding private var isRecordTooltipOn: Bool
    private let onTapped: () -> Void
    
    public init(
        isRecoding: Binding<Bool>,
        isRecordTooltipOn: Binding<Bool>,
        onTapped: @escaping () -> Void
    ) {
        self._isRecoding = isRecoding
        self._isRecordTooltipOn = isRecordTooltipOn
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button {
            onTapped()
        } label: {
            if isRecoding {
                Image.clogUI.recordingButton
                    .resizable()
                    .frame(width: 70, height: 70)
                    .animation(.easeInOut(duration: 0.5), value: isRecoding)
            } else {
                Image.clogUI.recodeButton
                    .resizable()
                    .foregroundStyle(
                        isEnabled ?
                        Color.clogUI.white :
                        Color.clogUI.gray400
                    )
                    .frame(width: 70, height: 70)
                    .animation(.easeInOut(duration: 0.5), value: isRecoding)
                    .tooltip(text: "촬영 버튼을 눌러\n영상 기록을 시작할 수 있어요!", position: .topCenter, verticalOffset: 40, isVisible: isRecordTooltipOn)
                    
            }
        }
    }
}

// MARK: - Preview
private struct RecodingTestView: View {
    @State var isRecoding: Bool
    
    var body: some View {
        RecodingButton(isRecoding: $isRecoding, isRecordTooltipOn: .constant(true)) {
            isRecoding.toggle()
        }
        .disabled(false)
    }
}

#Preview {
    ZStack {
        RecodingTestView(isRecoding: false)
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .background(Color.clogUI.gray700)
}

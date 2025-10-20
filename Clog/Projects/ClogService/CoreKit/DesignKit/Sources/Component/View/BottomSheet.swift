//
//  BottomSheet.swift
//  DesignKit
//
//  Created by Junyoung on 3/4/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public extension View {
    func bottomSheet<SheetContent: View>(
        isPresented: Binding<Bool>,
        height: CGFloat = 0,
        @ViewBuilder content: @escaping () -> SheetContent
    ) -> some View {
        modifier(
            BottomSheetModifier(
                isPresented: isPresented,
                sheetContent: content,
                height: height
            )
        )
    }
}

struct BottomSheetModifier<SheetContent: View>: ViewModifier {
    @Binding var isPresented: Bool
    let sheetContent: () -> SheetContent
    let height: CGFloat
    
    func body(content: Content) -> some View {
        ZStack {
            content
                .sheet(isPresented: $isPresented) {
                    BottomSheetView(
                        height: height,
                        content: sheetContent
                    )
                }.zIndex(.zero)
        }
    }
}

struct BottomSheetView<SheetContent: View>: View {
    @State var dynamicHeight: CGFloat = 0
    let content: () -> SheetContent
    let height: CGFloat
    
    init(
        height: CGFloat,
        content: @escaping () -> SheetContent
    ) {
        self.height = height
        self.dynamicHeight = 0
        self.content = content
    }
    
    var body: some View {
        VStack(spacing: 5) {
            Capsule()
                .fill(Color.clogUI.gray500)
                .frame(width: 36, height: 6)
                .padding(.top, 20)
                .padding(.bottom, 10)
            
            ScrollView {
                content()
                    .background(
                        GeometryReader { geometry in
                            Color.clear
                                .onAppear {
                                    if height == 0 {
                                        DispatchQueue.main.async {
                                            dynamicHeight += geometry.size.height
                                        }
                                    }
                                }
                        }
                    )
            }
        }
        .frame(maxWidth: .infinity)
        .presentationBackground(Color.clogUI.gray800)
        .background(
            GeometryReader { geometry in
                Color.clear
                    .onAppear {
                        if height == 0 {
                            DispatchQueue.main.async {
                                dynamicHeight += geometry.size.height
                            }
                        }
                    }
            }
        )
        .presentationDetents([.height(height == 0 ? dynamicHeight : height)])
    }
}

// MARK: Preview
struct ContainerBottomSheetView: View {
    @State private var isPresent: Bool
    
    init(isPresent: Bool = false) {
        self.isPresent = isPresent
    }
    
    var body: some View {
        Button {
            isPresent = true
        } label: {
            Text("bottom Sheet")
        }
        .bottomSheet(isPresented: $isPresent) {
            VStack(alignment: .leading) {
                Text("클라이밍파크 강남점")
                    .foregroundStyle(Color.clogUI.white)
                ForEach(0..<2) { _ in
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.clogUI.gray700)
                        .frame(height: 74)
                        .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

#Preview {
    ContainerBottomSheetView()
}

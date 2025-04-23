//
//  Tooltip.swift
//  DesignKit
//
//  Created by seunghwan Lee on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct Tooltip: View {
    public enum Position {
        /// 툴팁 위치 타겟뷰 상단, offset: 몸통 leading 기준 offset
        case topLeading(offset: CGFloat)
        /// 툴팁 위치 타겟뷰 상단, offset: 몸통 trailing 기준 offset
        case topTrailing(offset: CGFloat)
        /// 툴팁 위치 타겟뷰 하단, offset: 몸통 leading 기준 offset
        case bottomLeading(offset: CGFloat)
        /// 툴팁 위치 타겟뷰 하단, offset: 몸통 trailing 기준 offset
        case bottomTrailing(offset: CGFloat)
        case topCenter
        case bottomCenter
        
        var alignment: Alignment {
            switch self {
            case .topLeading, .bottomLeading:
                return .leading
            case .topTrailing, .bottomTrailing:
                return .trailing
            case .topCenter, .bottomCenter:
                return .center
            }
        }
        
        var xAxisOffset: CGFloat {
            switch self {
            case .topLeading(let offset), .topTrailing(let offset),
                 .bottomLeading(let offset), .bottomTrailing(let offset):
                return offset
            case .topCenter, .bottomCenter:
                return 0
            }
        }
        
        var isOnTop: Bool {
            switch self {
            case .topLeading, .topTrailing, .topCenter:
                return false
            case .bottomLeading, .bottomTrailing, .bottomCenter:
                return true
            }
        }
    }
    
    private let position: Position
    private let text: String
    @State private var contentWidth: CGFloat = 0
    
    public init(position: Position, text: String) {
        self.position = position
        self.text = text
    }
    
    private var tip: some View {
        Triangle()
            .frame(width: 11, height: 8)
            .foregroundColor(Color.clogUI.primary)
            .rotationEffect(position.isOnTop ? .degrees(0) : .degrees(180))
            .offset(x: position.xAxisOffset, y: 0)
            .frame(maxWidth: contentWidth, alignment: position.alignment)
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            if position.isOnTop {
                tip
            }
            
            Text(text)
                .multilineTextAlignment(.center)
                .foregroundStyle(Color.clogUI.gray900)
                .font(.b2)
                .padding(.horizontal, 14)
                .padding(.vertical, 8)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundStyle(Color.clogUI.primary)
                )
                .overlay {
                    GeometryReader { geometry in
                        Color.clear
                            .onAppear {
                                contentWidth = geometry.size.width
                            }
                    }
                }
            
            if position.isOnTop == false {
                tip
            }
        }
    }
}

private extension Tooltip {
    struct Triangle: Shape {
        func path(in rect: CGRect) -> Path {
            var path = Path()
            
            path.move(to: CGPoint(x: rect.midX, y: rect.minY))
            path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
            path.addLine(to: CGPoint(x: rect.minX, y: rect.maxY))
            path.closeSubpath()
            
            return path
        }
    }
}

// MARK: - Modifier & View Extension
struct TooltipModifier: ViewModifier {
    private let text: String
    private let position: Tooltip.Position
    private let verticalOffset: CGFloat
    private let isVisible: Bool
    @State private var tooltipSize: CGSize = .zero
    private let onTouchHandeler: (() -> Void)?
    
    init(text: String, position: Tooltip.Position, verticalOffset: CGFloat, isVisible: Bool = true, onTouchHandeler: (() -> Void)?) {
        self.text = text
        self.position = position
        self.verticalOffset = verticalOffset
        self.isVisible = isVisible
        self.onTouchHandeler = onTouchHandeler
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                GeometryReader { geometry in
                    if isVisible {
                        Tooltip(position: position, text: text)
                            .fixedSize()
                            .background(
                                GeometryReader { tooltipGeometry in
                                    Color.clear
                                        .onAppear {
                                            tooltipSize = tooltipGeometry.size
                                        }
                                }
                            )
                            .onTapGesture {
                                onTouchHandeler?()
                            }
                        .position(
                            x: tooltipXPos(targetViewWidth: geometry.size.width, toolTipWidth: tooltipSize.width),
                            y: position.isOnTop
                                ? geometry.size.height + tooltipSize.height / 2 + verticalOffset
                                : -tooltipSize.height / 2 - verticalOffset
                        )
                    }
                }
            )
    }
    
    private func tooltipXPos(targetViewWidth: CGFloat, toolTipWidth: CGFloat) -> CGFloat {
        let tipWidth: CGFloat = 11
        
        switch position {
        case .topLeading(let offset), .bottomLeading(let offset):
            return targetViewWidth / 2 + toolTipWidth / 2 - tipWidth / 2 - offset
        case .topTrailing(let offset), .bottomTrailing(let offset):
            return targetViewWidth / 2 - toolTipWidth / 2 + tipWidth / 2 - offset
        case .topCenter, .bottomCenter:
            return targetViewWidth / 2
        }
    }
}

public extension View {
    func tooltip(text: String,
                 position: Tooltip.Position,
                 verticalOffset: CGFloat = 0,
                 isVisible: Bool = true,
                 onTouchHandeler: (() -> Void)? = nil
    ) -> some View {
        return self.modifier(TooltipModifier(text: text, position: position, verticalOffset: verticalOffset, isVisible: isVisible, onTouchHandeler: onTouchHandeler))
    }
}

// MARK: - preview
struct TooltipModifierPreview: PreviewProvider {
    struct TooltipTestTargetView: View {
        let text: String
        
        init(_ text: String) {
            self.text = text
        }
        
        var body: some View {
            Text(text)
                .padding()
                .background(Color.gray.opacity(0.2))
                .cornerRadius(8)
        }
    }
    
    static var previews: some View {
        VStack(spacing: 0) {
            TooltipTestTargetView("상단 툴팁")
                .tooltip(
                    text:
                         """
                         촬영 버튼을 눌러
                         영상 기록을 시작할 수 있어요!
                         """,
                    position: .topCenter,
                    isVisible: true
                )
            
            Spacer()
                .frame(height: 50)
            
            TooltipTestTargetView("하단 툴팁")
                .tooltip(
                    text:
                        """
                        스탬프 버튼을 눌러
                        중요 부분을 기록할 수 있어요!
                        """
                    ,
                    position: .bottomCenter,
                    verticalOffset: 10,
                    isVisible: true
                )
            
            Spacer()
                .frame(height: 180)
            
            TooltipTestTargetView("topLeadingOffset 툴팁")
                .tooltip(text: "툴팁 위치 상단, 몸통 Leading 기준\n팁 우측으로 20만큼 떨어진곳 위치", position: .topLeading(offset: 20), isVisible: true)
            
            Spacer()
                .frame(height: 50)
            
            TooltipTestTargetView("bottomTrailingOffset 툴팁")
                .tooltip(text: "툴팁 위치 하단, 몸통 trailing 기준\n팁 좌측으로 20만큼 떨어진곳 위치", position: .bottomTrailing(offset: -20), verticalOffset: 3, isVisible: true)
        }
    }
}

//
//  GeneralButton.swift
//  DesignKit
//
//  Created by Junyoung on 2/28/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

// MARK: - Button View
public struct GeneralButton: View {
    private var configuration: GeneralButtonConfiguration
    @Environment(\.isEnabled) private var isEnabled: Bool
    private var onTapped: () -> Void
    
    public init(
        _ text: String,
        _ onTapped: @escaping () -> Void
    ) {
        self.onTapped = onTapped
        self.configuration = GeneralButtonConfiguration(
            style: .normal,
            text: text
        )
    }
    fileprivate init(
        _ configuration: GeneralButtonConfiguration,
        onTapped: @escaping () -> Void
    ) {
        self.configuration = configuration
        self.onTapped = onTapped
    }
    
    public var body: some View {
        Button(action: {
            onTapped()
        }, label: {
            Text(configuration.text)
                .font(.b1)
                .padding(.vertical, 15)
                .frame(maxWidth: .infinity)
                .foregroundStyle(
                    isEnabled ?
                    configuration.style.foregroundColor :
                    Color.clogUI.gray400
                )
                .background(
                    isEnabled ?
                    configuration.style.backgroundColor :
                    Color.clogUI.gray700
                )
                .cornerRadius(12)
        })
    }
}

// MARK: - Button Configuration
public struct GeneralButtonConfiguration {
    var style: GeneralButtonStyle
    var text: String
}

// MARK: Button Style
public enum GeneralButtonStyle {
    case normal
    case white
    case error
    
    var foregroundColor: Color {
        switch self {
        case .normal:
            return Color.clogUI.white
        case .white:
            return Color.clogUI.gray800
        case .error:
            return Color.clogUI.white
        }
    }
    
    var backgroundColor: Color {
        switch self {
        case .normal:
            return Color.clogUI.gray600
        case .white:
            return Color.clogUI.white
        case .error:
            return Color.clogUI.fail
        }
    }
}

// MARK: - Button Extension
public extension GeneralButton {
    func style(_ style: GeneralButtonStyle) -> GeneralButton {
        
        var newConfig = self.configuration
        
        newConfig.style = style
            
        return GeneralButton(newConfig, onTapped: self.onTapped)
    }
}

// MARK: - Preview
#Preview {
    
    VStack {
        Text("Normal")
            .foregroundStyle(Color.clogUI.white)
            .font(.h1)
        HStack {
            VStack {
                Text("Enable")
                    .foregroundStyle(Color.clogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.normal)
            }
            
            VStack {
                Text("Disable")
                    .foregroundStyle(Color.clogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.normal)
                .disabled(true)
            }
        }
        .padding(.bottom, 10)
        
        Text("White")
            .foregroundStyle(Color.clogUI.white)
            .font(.h1)
        HStack {
            VStack {
                Text("Enable")
                    .foregroundStyle(Color.clogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.white)
            }
            
            VStack {
                Text("Disable")
                    .foregroundStyle(Color.clogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.white)
                .disabled(true)
            }
        }
        .padding(.bottom, 10)
        
        Text("Error")
            .foregroundStyle(Color.clogUI.white)
            .font(.h1)
        HStack {
            VStack {
                Text("Enable")
                    .foregroundStyle(Color.clogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.error)
            }
            
            VStack {
                Text("Disable")
                    .foregroundStyle(Color.clogUI.white)
                GeneralButton("버튼입니다") {
                    
                }
                .style(.error)
                .disabled(true)
            }
        }
    }
    .padding(16)
    .background(Color.clogUI.gray800)
}


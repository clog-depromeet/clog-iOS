//
//  ClLogTextField.swift
//  DesignKit
//
//  Created by Junyoung on 3/3/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

public struct ClLogTextInput: View {
    @Binding private var text: String
    private let placeHolder: String
    @FocusState private var focusState: Bool
    @Binding private var isFocused: Bool
    private var configuration: TextInputConfiguration
    @State var foregroundColor: Color = Color.clogUI.white
    
    public init(
        placeHolder: String,
        text: Binding<String>,
        isFocused: Binding<Bool>
    ) {
        self.placeHolder = placeHolder
        self._isFocused = isFocused
        self._text = text
        self.configuration = TextInputConfiguration(
            state: .normal,
            type: .filed,
            background: .gray900
        )
    }
    
    fileprivate init(
        _ placeHolder: String,
        _ text: Binding<String>,
        _ configuration: TextInputConfiguration,
        _ isFocused: Binding<Bool>
    ) {
        self.placeHolder = placeHolder
        self._text = text
        self._isFocused = isFocused
        self.configuration = configuration
    }
    
    public var body: some View {
        makeBody()
    }
}

extension ClLogTextInput {
    fileprivate func makeBody() -> some View {
        ZStack(
            alignment: configuration.type == .editor ?
                .topLeading : .center
        ) {
            switch configuration.type {
            case .filed:
                // TextField
                TextField("", text: $text)
                    .padding(.horizontal, 16)
                    .tint(configuration.state.foregroundColor)
                    .foregroundColor(foregroundColor)
                    .focused($focusState)
            case .editor:
                // TextEditor
                TextEditor(text: $text)
                    .foregroundStyle(foregroundColor)
                    .scrollContentBackground(.hidden)
                    .padding(16)
                    .tint(configuration.state.foregroundColor)
                    .focused($focusState)
            }
            
            // PlaceHolder
            if !focusState && text.isEmpty {
                Text(placeHolder)
                    .foregroundStyle(Color.clogUI.gray400)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, 16)
                    .padding(.vertical, configuration.type == .editor ? 16 : 0)
            }
        }
        .onChange(of: configuration.state, { oldValue, newValue in
            foregroundColor = newValue.foregroundColor
        })
        .font(.b1)
        .frame(height: configuration.type == .editor ? 128 : 48)
        .background(configuration.background.color)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay (
            Group {
                if case .error = configuration.state {
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(
                            Color.clogUI.fail,
                            lineWidth: 1
                        )
                }
            }
        )
        .disabled(configuration.state == .disable)
        .onChange(of: isFocused) { oldValue, newValue in
            focusState = newValue
        }
        .onChange(of: focusState) { oldValue, newValue in
            isFocused = newValue
        }
    }
    
    public func state(_ state: TextInputState) -> ClLogTextInput {
        var newConfig = self.configuration
        
        newConfig.state = state
        
        return ClLogTextInput(self.placeHolder ,$text, newConfig, $isFocused)
    }
    
    public func type(_ type: TextInputType) -> ClLogTextInput {
        var newConfig = self.configuration
        
        newConfig.type = type
        
        return ClLogTextInput(self.placeHolder ,$text, newConfig, $isFocused)
    }
    
    public func background(_ type: TextInputBackground) -> ClLogTextInput {
        var newConfig = self.configuration
        
        newConfig.background = type
        
        return ClLogTextInput(self.placeHolder ,$text, newConfig, $isFocused)
    }
}

// MARK: - Preview
public struct ContainerClLogTextField: View {
    @State private var textNormal: String
    @State private var textDisable: String
    @State private var textError: String
    
    init(
        textNormal: String,
        textDisable: String,
        textError: String
    ) {
        self.textNormal = textNormal
        self.textDisable = textDisable
        self.textError = textError
    }
    
    public var body: some View {
        GroupBox(label: Text("Normal")) {
            ClLogTextInput(
                placeHolder: "암장을 입력해 주세요",
                text: $textNormal,
                isFocused: .constant(true)
            )
            .state(.normal)
        }
        
        GroupBox(label: Text("Edior Error")) {
            ClLogTextInput(
                placeHolder: "암장을 입력해 주세요",
                text: $textDisable,
                isFocused: .constant(true)
            )
            .type(.editor)
            .state(.error)
        }
        
        GroupBox(label: Text("Disable")) {
            ClLogTextInput(
                placeHolder: "암장을 입력해 주세요",
                text: $textError,
                isFocused: .constant(true)
            )
            .state(.disable)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        ContainerClLogTextField(
            textNormal: "",
            textDisable: "",
            textError: ""
        )
    }
}

//
//  NickNameFeature.swift
//  NickNameFeature
//
//  Created by Junyoung on 3/30/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import AccountDomain
import ComposableArchitecture
import DesignKit

@Reducer
public struct NickNameFeature {
    @Dependency(\.accountUseCase) private var accountUseCase
    
    @ObservableState
    public struct State: Equatable {
        var viewState: NickNameViewState
        
        // button State
        var disabled: Bool = true
        
        // textFieldState
        var textCount: Int = 0
        var text: String = ""
        var focused: Bool = true
        var textFieldState: TextInputState = .normal
        
        public init(viewState: NickNameViewState) {
            self.viewState = viewState
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case backButtonTapped
        case confirmButtonTapped
        case focusOut
        
        case updateSuccess
        case errorHandler(Error)
    }
    
    public init() {}
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        
        Reduce(reducerCore)
    }
}

extension NickNameFeature {
    func reducerCore(_ state: inout State, _ action: Action) -> Effect<Action> {
        switch action {
        case .binding(\.text):
            // Text 카운팅
            state.textCount = state.text.count
            
            // 공백 및 특수문자 확인, 텍스트 10 글자 초과
            if containsWhitespaceOrSpecialCharacter(state.text)
                || state.text.count > 10
                || state.text.count == 0
            {
                state.textFieldState = .error
                state.disabled = true
                return .none
            }
            
            state.textFieldState = .normal
            state.disabled = false
            
            return .none
            
        case .focusOut:
            state.focused = false
            return .none
            
        case .confirmButtonTapped:
            return updateNickName(state.text)
            
        default:
            return .none
        }
    }
    
    private func updateNickName(_ text: String) -> Effect<Action> {
        .run { send in
            do {
                try await accountUseCase.updateName(text)
                await send(.updateSuccess)
            } catch {
                await send(.errorHandler(error))
            }
        }
    }
    
    private func containsWhitespaceOrSpecialCharacter(_ text: String) -> Bool {
        let specialCharacterSet = CharacterSet.alphanumerics.inverted
        return text.rangeOfCharacter(from: .whitespaces) != nil ||
               text.rangeOfCharacter(from: specialCharacterSet) != nil
    }
}

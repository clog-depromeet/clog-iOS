//
//  DialogView.swift
//  DesignKit
//
//  Created by Junyoung on 3/7/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture

public enum DialogStyle {
    case `default`
    case delete
    
    var button: GeneralButtonStyle {
        switch self {
        case .default:
            return .white
        case .delete:
            return .error
        }
    }
}

struct DialogView: View {
    @Binding var isPresented: Bool
    @State var isShowAnimation: Bool = false
    let model: DialogModel
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()
                .transition(.opacity)
                .onTapGesture {
                    closeDialog()
                }
            
            makeDialogView(model)
                .padding(.horizontal, 24)
                .scaleEffect(isShowAnimation ? 1 : 0.8)
                .animation(.spring(response: 0.4, dampingFraction: 0.7), value: isShowAnimation)
                .transition(.opacity.combined(with: .scale))
        }
        .opacity(isShowAnimation ? 1 : 0)
    }
    
    private func makeDialogView(_ model: DialogModel) -> some View {
        VStack(spacing: 24) {
            VStack(spacing: 14) {
                Text(model.title)
                    .font(.h2)
                    .foregroundStyle(Color.clogUI.white)
                    .frame(alignment: .center)
                Text(model.message)
                    .font(.b1)
                    .foregroundStyle(Color.clogUI.gray300)
                    .multilineTextAlignment(.center)
            }
            HStack(spacing: 10) {
                ForEach(model.buttons.reversed(), id: \.self) { buttonState in
                    GeneralButton(buttonState.title) {
                        buttonState.action()
                        closeDialog()
                    }
                    .style(
                        buttonState == model.buttons.first ?
                        buttonState.style.button : .normal
                    )
                }
                
            }
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 20)
        .background(Color.clogUI.gray700)
        .clipShape(RoundedRectangle(cornerRadius: 20))
        .onChange(of: isPresented, { oldValue, newValue in
            if newValue {
                isShowAnimation = true
            }
        })
    }
    
    private func closeDialog() {
        withAnimation {
            isShowAnimation = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}

// MARK: - Preview & Example
struct DialogExampleView : View {
    @Bindable var store: StoreOf<DialogExampleFeature>

    var body: some View {
        Button {
            store.send(.showDialogTapped)
        } label: {
            Text("show dialog")
        }
        .presentDialog($store.scope(state: \.alert, action: \.alert), style: .delete)
    }
}

@Reducer
struct DialogExampleFeature {
    @ObservableState
    struct State {
        @Presents var alert: AlertState<Action.Dialog>?
    }
    
    enum Action: BindableAction {
        case binding(BindingAction<State>)
        
        case showDialogTapped
        case alert(PresentationAction<Dialog>)
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
            case cancel
        }
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .showDialogTapped:
                state.alert = AlertState {
                    TextState("제목입니다.")
                } actions: {
                    ButtonState(action: .confirm) {
                        TextState("삭제")
                    }
                    ButtonState(action: .cancel) {
                        TextState("취소")
                    }
                } message: {
                    TextState("서브 타이틀 메세지 입니다.")
                }
                return .none
            case .alert(.presented(.confirm)):
                print("확인")
                return .none
            case .alert(.presented(.cancel)):
                print("취소")
                return .none
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}


#Preview {
    DialogExampleView(store: .init(initialState: DialogExampleFeature.State(), reducer: {
        DialogExampleFeature()
    }))
}

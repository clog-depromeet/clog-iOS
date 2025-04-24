//
//  CalendarDetailView.swift
//  CalendarFeature
//
//  Created by Junyoung on 3/9/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI

import ComposableArchitecture
import DesignKit

public struct CalendarDetailView: View {
    @Bindable private var store: StoreOf<CalendarDetailFeature>
    @State private var isFocused: Bool = false
    
    public init(store: StoreOf<CalendarDetailFeature>) {
        self.store = store
    }
    
    public var body: some View {
        makeBody()
            .background(Color.clogUI.gray800)
            .onAppear {
                store.send(.onAppear)
            }
            .bottomSheet(isPresented: $store.isPresentMoreBottomSheet) {
                VStack(spacing: 0) {
                    ForEach(store.moreBottomSheetItem, id: \.self) { item in
                        MoreItemRow(item: item) { selectedItem in
                            store.send(.moreItemTapped(selectedItem))
                        }
                    }
                }
                .padding(16)
            }
            .onTapGesture {
                store.send(.screenTapped)
            }
            .presentDialog($store.scope(state: \.alert, action: \.alert), style: .delete)
    }
}

extension CalendarDetailView {
    func makeBody() -> some View {
        VStack(spacing: 0) {
            makeAppBar()
            ScrollView {
                makeContent()
                    .padding(16)
            }
        }
    }
    
    func makeAppBar() -> some View {
        AppBar {
            Button {
                store.send(.backButtonTapped)
            } label: {
                Image.clogUI.back
                    .resizable()
                    .frame(width: 24, height: 24)
                    .foregroundStyle(Color.clogUI.white)
            }

        } rightContent: {
            HStack(spacing: 20) {
                if store.isMemoEditMode {
                    Button {
                        store.send(.editCompleteTapped)
                    } label: {
                        Text("완료")
                            .font(.h4)
                            .foregroundStyle(Color.clogUI.white)
                    }
                } else {
                    // TODO: 공유 버튼 작업
    //                Button {
    //                    store.send(.shareButtonTapped)
    //                } label: {
    //                    Image.clogUI.share
    //                        .resizable()
    //                        .frame(width: 24, height: 24)
    //                        .foregroundStyle(Color.clogUI.white)
    //                }
                    Button {
                        store.send(.moreButtonTapped)
                    } label: {
                        Image.clogUI.dotVertical
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundStyle(Color.clogUI.white)
                    }
                }
            }
        }
    }
    
    func makeContent() -> some View {
        VStack(spacing: 20) {
            userInfoView()
            problemListView()
            Spacer()
        }
    }
    
    func userInfoView() -> some View {
        UserInfoView(
            type: .detail,
            isFocused: $store.isFocused,
            store: store.scope(state: \.userInfoState, action: \.userInfoAction)
        )
    }
    
    func problemListView() -> some View {
        StoriesView(
            store: store.scope(state: \.storiesState, action: \.storiesAction)
        )
    }
}

#Preview {
    CalendarDetailView(
        store: .init(
            initialState: CalendarDetailFeature.State(storyId: 0),
            reducer: {
                CalendarDetailFeature()
            }
        )
    )
}

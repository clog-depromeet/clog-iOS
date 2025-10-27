//
//  CragBottomSheet.swift
//  DesignKit
//
//  Created by soi on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import Combine

public extension View {
    func showCragBottomSheet(
        isPresented: Binding<Bool>,
        didTapSaveButton: @escaping (DesignCrag) -> Void,
        didTapSkipButton: @escaping () -> Void,
        didNearEnd: @escaping () -> Void,
        didChangeSearchText: @escaping (String) -> Void,
        matchesPattern: @escaping (DesignCrag, String) -> Bool,
        crags: Binding<[DesignCrag]>
    ) -> some View {
        self.bottomSheet(isPresented: isPresented) {
            SelectCragView(
                didTapSaveButton: didTapSaveButton,
                didTapSkipButton: didTapSkipButton,
                didChangeSearchText: didChangeSearchText,
                didNearEnd: didNearEnd,
                matchesPattern: matchesPattern,
                crags: crags
            )
            
        }
    }
}

public struct DesignCrag: Hashable, Identifiable {
    
    public init(id: Int, name: String, address: String) {
        self.id = id
        self.name = name
        self.address = address
    }
    
    public let id: Int
    public let name: String
    public let address: String
}

struct SelectCragView: View {
    
    public init(
        didTapSaveButton: @escaping (DesignCrag) -> Void,
        didTapSkipButton: @escaping () -> Void,
        didChangeSearchText: @escaping (String) -> Void,
        didNearEnd: @escaping () -> Void,
        matchesPattern: @escaping (DesignCrag, String) -> Bool,
        crags: Binding<[DesignCrag]>
    ) {
        self.didTapSaveButton = didTapSaveButton
        self.didTapSkipButton = didTapSkipButton
        self.didChangeSearchText = didChangeSearchText
        self.didNearEnd = didNearEnd
        self.matchesPattern = matchesPattern
        self._crags = crags
    }
    
    private var didTapSaveButton: (DesignCrag) -> Void
    private var didTapSkipButton: () -> Void
    private var didChangeSearchText: (String) -> Void
    private var didNearEnd: () -> Void
    private let matchesPattern: (DesignCrag, String) -> Bool
    
    @State private var searchText = ""
    @Binding private var crags: [DesignCrag]
    @State private var selectedCrag: DesignCrag?
    @FocusState private var isFocused: Bool
    @State private var debounceWorkItem: DispatchWorkItem?
    @State private var isLoading = false
    
    var body: some View {
        VStack(alignment: .leading) {
            cragTitleSection
            cragSelectionSection
            buttonSection
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.clogUI.gray800)
        .onChange(of: searchText) { _, newValue in
            debounceSearchText(newValue)
        }
    }
    
    private var cragTitleSection: some View {
        VStack(alignment: .leading) {
            Text("암장명")
                .font(.h3)
                .foregroundStyle(Color.clogUI.white)
            
            ClLogTextInput(
                placeHolder: "암장을 입력해주세요",
                text: $searchText,
                isFocused: .constant(true)
            )
            .focused($isFocused)
        }
    }
    
    private var cragSelectionSection: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(crags, id: \.id) { crag in
                    TwoLineRow(
                        title: crag.name,
                        subtitle: crag.address
                    )
                    .background(
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundStyle(
                                selectedCrag == crag
                                ? Color.clogUI.gray700
                                : Color.clogUI.gray800
                            )
                    )
                    .onTapGesture {
                        selectedCrag = crag
                        isFocused = false
                    }
                }
                
                Color.clear
                    .frame(height: 10)
                    .onAppear {
                        didNearEnd()
                    }
            }
        }
        .frame(height: 300) // TODO: 컨텐츠 사이즈 기반 동적 높이 적용
    }
    
    private var buttonSection: some View {
        HStack {
            GeneralButton("건너뛰기") {
                didTapSkipButton()
            }
            
            GeneralButton("저장하기") {
                guard let selectedCrag else { return }
                didTapSaveButton(selectedCrag)
            }
            .style(.white)
            .disabled(selectedCrag == nil)
        }
    }
    
    private func debounceSearchText(_ text: String) {
        debounceWorkItem?.cancel()
        
        isLoading = !text.isEmpty
        
        let workItem = DispatchWorkItem {
            didChangeSearchText(text)
            isLoading = false
        }
        
        debounceWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: workItem)
    }
}

struct SelectCragView_Previews: PreviewProvider {
    static var previews: some View {
        SelectCragView(
            didTapSaveButton: { crag in
                print("저장된 암장: \(crag.name)")
            },
            didTapSkipButton: {
                print("건너뛰기 버튼 클릭됨")
            },
            didChangeSearchText: { _ in
            },
            didNearEnd: { },
            matchesPattern: { _, _ in
                true
            },
            crags: .constant([
                DesignCrag(id: 0, name: "강남점", address: "서울 강남구"),
                DesignCrag(id: 1, name: "홍대점", address: "서울 마포구"),
                DesignCrag(id: 2, name: "신촌점", address: "서울 서대문구")
            ])
        )
    }
}

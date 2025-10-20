//
//  AttemptFeature.swift
//  FolderFeature
//
//  Created by soi on 3/19/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import SwiftUI
import Domain
import FolderDomain
import DesignKit
import Shared
import Core
import VideoFeatureInterface

import ComposableArchitecture

@Reducer
public struct AttemptFeature {
    
    @Dependency(\.attemptUseCase) private var attemptUseCase
    @Dependency(\.nearByCragUseCase) private var cragUseCase
    @Dependency(\.gradeUseCase) private var gradeUseCase
    @Dependency(\.videoDataManager) private var videoDataManager
    
    public init() {}
    
    @ObservableState
    public struct State: Equatable {
        
        public init(attemptId: Int) {
            self.attemptId = attemptId
        }
        
        @Presents var alert: AlertState<Action.Dialog>?
        
        let attemptId: Int
        var attempt: ReadAttempt?
        var showLoadingView = false
        var videoURL: URL?
        let editActions = AttemptEditAction.allCases
        
        var showVideoControlButton = false
        var loadedVideo = false
        var isPlaying = false
        var progress: Double = 0
        var seekTime: Int?
        var selectedAction: AttemptEditAction?
        var stampPositions = [CGFloat]()
        
        var nearByCrags = [DesignCrag]()
        var selectedCragGrades = [Grade]()
        
        // 난이도 & 암장 수정 -> 연결되는 State
        var selectedEditCrag: Crag?
        var selectedEditGrade: Grade?
        var selectedEditCragGrades: [Grade]?
        
        // Bottom sheet
        var showEditAttemptBottomSheet = false
        var showCragBottomSheet = false
        var showGradeBottomSheet = false

        var sharedPath: URL?
        var sharedShow: Bool = false

        var dynamicSheetHeight: CGFloat {
            switch selectedAction {
//            case .video:
//                251
            case .result:
                210
            case .info:
                700
            case .delete:
                250
            case nil: 230
            }
        }
        
        // ViewState
        var viewState: ViewState = .normal
        
        public enum ViewState {
            case normal
            case error
        }
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case alert(PresentationAction<Dialog>)
        
        case onAppear
        case backButtonTapped
        case shareButtonTapped
        case shareSetPath(URL)
        case moreButtonTapped
        case moreActionTapped(_ action: AttemptEditAction)
        case videoTapped
        case stampTapped(id: Int)
        case loadMoreCrags
        
        case onSplitPositionsCalculated(positions: [CGFloat])
        case getAttempt(attempt: ReadAttempt)
        case getAssetURL(url: URL)
        case getNearByCrags(_ crags: [Crag])
        case getMoreNearByCrags(_ crags: [Crag])
        case getCragGrades(_ grades: [Grade])
        
        // edit actions
        case onEditSheetDismissed
        case editBackButtonTapped
        case deleteActionTapped
        case videoControlTapped
        case editCragTapped
        case didTapSaveGradeTapped(id: Int?)
        case cancelEditCragTapped
        case saveEditCragTapped(crag: Crag)
        case attemptResultActionTapped(attempt: AttemptResult)
        case patchedResult(_ result: AttemptResult)
        case patchedInfo(_ grade: Grade?, crag: Crag?)
        case skipEditCragTapped
        case deletedAttempt
        case deleteAttemptFinished
        case cragName(keyWord: String)
        
        // errorHandler
        case errorHandler(Error)
        
        @CasePathable
        public enum Dialog: Equatable {
            case cancel
            case delete
        }
    }
    
    public var body: some Reducer<State, Action> {
        BindingReducer()
        Reduce { state, action in
            switch action {
            case .binding:
                return .none
                
            case .onAppear:
                return fetchAttempt(state.attemptId)
            case .backButtonTapped:
                return .none
            case .shareButtonTapped:
                return .run { [state] send in
                    do {
                        let attempt = try await attemptUseCase.execute(attemptId: state.attemptId)
                        let url = try await MediaUtility.getURL(fromAssetID: attempt.attempt.video.localPath)
                        await send(.shareSetPath(url))
                    } catch {
                        await send(.errorHandler(error))
                    }
                }
            case .shareSetPath(let path):
                state.sharedPath = path
                state.sharedShow = true
                return .none
            case .moreButtonTapped:
                state.selectedEditCrag = state.attempt?.crag
                state.selectedEditGrade = state.attempt?.grade
                state.selectedEditCragGrades = nil
                state.showEditAttemptBottomSheet = true
                return .none
            case .moreActionTapped(let action):
                
                switch action {
//                case .video,
//                    state.selectedAction = action
//                    return .none
                    
                case .result:
                    state.selectedAction = action
                    return .none
                case .info:
                    if let currentCragId = state.attempt?.crag?.id {
                        state.showLoadingView = true
                        return fetchGrades(cragId: currentCragId)
                    }
                    return fetchNearByCrags()
                case .delete:
                    return .send(.deleteActionTapped)
                }
            case .videoTapped:
                guard state.loadedVideo else {
                    return .none
                }
                state.showVideoControlButton.toggle()
                return .none
            case .stampTapped(let id):
                let stamp = state.attempt?.attempt.video.stamps.first(where: { $0.id == id })
                state.seekTime = stamp?.timeMs
                return .none
            case .loadMoreCrags:
                return fetchMoreNearByCrags()
                
            case .onSplitPositionsCalculated(let positions):
                state.stampPositions = positions
                return .none
            case .getAttempt(let attempt):
                state.attempt = attempt
                state.selectedEditGrade = attempt.grade
                state.selectedEditCrag = attempt.crag
                return .none
            case .getAssetURL(let url):
                state.loadedVideo = true
                state.videoURL = url
                return .none
                
            // MARK: Bottom Sheet
            case .editBackButtonTapped:
                state.selectedAction = nil
                return .none
                
            case .onEditSheetDismissed:
                state.selectedAction = nil
                return .none
                
            case .deleteActionTapped:
                state.showEditAttemptBottomSheet = false
                state.alert = AlertState {
                    TextState("영상 기록 삭제")
                } actions: {
                    ButtonState(action: .delete) {
                        TextState("삭제")
                    }
                    ButtonState(action: .cancel) {
                        TextState("취소")
                    }
                } message: {
                    TextState("기록을 삭제하면 복구가 어려워요.\n영상 기록을 삭제하시나요?")
                }
                return .none
            case .videoControlTapped:
                if state.isPlaying {
                    state.isPlaying = false
                } else {
                    state.isPlaying = true
                    state.showVideoControlButton = false
                }
                return .none
            case .deletedAttempt:
                return .none
                
            case .didTapSaveGradeTapped(let id):
                let grade = state.selectedCragGrades.first(where: { $0.id == id })
                guard let currentAttempt = state.attempt else {
                    return .none
                }
                return patchInfo(
                    attemptId: state.attemptId,
                    attempt: currentAttempt,
                    grade: grade,
                    crag: state.selectedEditCrag ?? state.attempt?.crag
                )
                
            case .editCragTapped:
                state.showGradeBottomSheet = false
                return fetchNearByCrags()
            case .cragName(let keyword):
                return fetchNearByCrags(keyword: keyword)
              
            case .attemptResultActionTapped(let newAction):
                guard let currentAttempt = state.attempt else {
                    return .none
                }
                return patchResult(
                    attemptId: state.attemptId,
                    attempt: currentAttempt,
                    result: newAction
                )
                
            case .skipEditCragTapped:
                state.selectedEditCrag = state.attempt?.crag
                state.selectedEditCragGrades = nil
                state.showEditAttemptBottomSheet = false
                state.showCragBottomSheet = false
                state.showGradeBottomSheet = true
                return .none
                
            case .saveEditCragTapped(let crag):
                state.selectedEditCrag = crag
                return fetchGrades(cragId: crag.id)
               
            case .patchedResult(let result):
                let newAttempt = state.attempt?.copyWith(result: result)
                state.showEditAttemptBottomSheet = false
                state.selectedAction = nil
                state.attempt = newAttempt
                return .none
                
            case .patchedInfo(let grade, let crag):
                let newAttempt = state.attempt?.copyWith(grade: grade, crag: crag)
                state.attempt = newAttempt
                state.selectedEditGrade = nil
                state.selectedEditCrag = nil
                state.showEditAttemptBottomSheet = false
                state.showCragBottomSheet = false
                state.showGradeBottomSheet = false
                return .none
                
            case .getNearByCrags(let crags):
                state.nearByCrags = crags.map {
                    DesignCrag(id: $0.id, name: $0.name, address: $0.address)
                }
                state.showEditAttemptBottomSheet = false
                state.showCragBottomSheet = true
                return .none
            case .getMoreNearByCrags(let crags):
                let newCrags = crags.map {
                    DesignCrag(id: $0.id, name: $0.name, address: $0.address)
                }
                state.nearByCrags.append(contentsOf: newCrags)
                return .none
            case .getCragGrades(let grades):
                state.showEditAttemptBottomSheet = false
                state.showLoadingView = false
                state.showGradeBottomSheet = true
                state.showCragBottomSheet = false
                state.selectedCragGrades = grades
                return .none
          
            case .alert(.presented(.cancel)):
                return .none
            case .alert(.presented(.delete)):
                return deleteAttempt(state.attemptId)
                
            case .errorHandler(let error):
                state.viewState = .error
                return .none
            default: return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

extension AttemptFeature {
    
    private func fetchAttempt(_ attemptId: Int) -> Effect<Action> {
        return .run { send in
            do {
                let attempt = try await attemptUseCase.execute(attemptId: attemptId)
                await send(.getAttempt(attempt: attempt))
                
                let url = try await MediaUtility.getURL(fromAssetID: attempt.attempt.video.localPath)
                print("localURL: \(url)")
                await send(.getAssetURL(url: url))
                
            } catch {
                // TODO: show error message
                await send(.errorHandler(error))
            }
        }
    }
    
    private func deleteAttempt(_ attemptId: Int) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.delete(attemptId: attemptId)
                
                await send(.deleteAttemptFinished)
            } catch  {
                // TODO: show error message
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func patchResult(attemptId: Int, attempt: ReadAttempt, result: AttemptResult) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.patchResult(attemptId: attemptId, attempt: attempt, result: result)
                await send(.patchedResult(result))
            } catch {
                // TODO: show error message
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchNearByCrags(keyword: String = "") -> Effect<Action> {
        return .run { send in
            do {
                let crags = try await cragUseCase.fetch(keyword: keyword, location: nil)
                await send(.getNearByCrags(crags))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchMoreNearByCrags() -> Effect<Action> {
        return .run { send in
            do {
                let crags = try await cragUseCase.next()
                await send(.getMoreNearByCrags(crags))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchGrades(cragId: Int) -> Effect<Action> {
        return .run { send in
            do {
                let grades = try await gradeUseCase.getCragGrades(cragId: cragId)
                await send(.getCragGrades(grades))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func patchInfo(attemptId: Int, attempt: ReadAttempt, grade: Grade?, crag: Crag?) -> Effect<Action> {
        return .run { send in
            do {
                try await attemptUseCase.patchInfo(attemptId: attemptId, attempt: attempt, grade: grade, crag: crag)
                await send(.patchedInfo(grade, crag: crag))
            }
        }
    }
}

extension AttemptFeature {
    public enum AttemptEditAction: CaseIterable {
//        case video
        case result
        case info
        case delete
        
        var title: String {
            switch self {
//            case .video:    "영상/스탬프 편집"
            case .result:   "완등/실패 수정"
            case .info:     "암장 정보, 난이도 수정"
            case .delete:   "영상 기록 삭제"
            }
        }
        
        var leadingIcon: Image {
            switch self {
//            case .video:    Image.clogUI.cut
            case .result:   Image.clogUI.tag
            case .info:     Image.clogUI.location
            case .delete:   Image.clogUI.delete
            }
        }
        
        var color: Color {
            switch self {
//            case .video,
            case .result, .info:
                Color.clogUI.white
            case .delete:
                Color.clogUI.fail
            }
        }
    }
}

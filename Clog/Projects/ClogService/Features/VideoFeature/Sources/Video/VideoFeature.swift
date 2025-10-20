//
//  VideoFeature.swift
//  VideoFeature
//
//  Created by lin.saeng on 3/14/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Shared

import ComposableArchitecture
import VideoFeatureInterface
import VideoDomain
import DesignKit
import UIKit

@Reducer
public struct VideoFeature {
    
    @Dependency(\.logConsole) var log
    @Dependency(\.videoPermission) var permissionUseCase
    @Dependency(\.gradeUseCase) var gradeUseCase
    @Dependency(\.registerProblemUseCase) var registerProblemUseCase
    @Dependency(\.videoDataManager) private var videoDataManager
    @Dependency(\.updateStoryStatusUseCase) private var updateStoryStatusUseCase
    
    private let permission: PermissionHandler
    
    @ObservableState
    public struct State: Equatable {
        // View State
        var viewState: ViewState = .normal
        
        // 카메라를 컨드롤하는 Model
        var cameraModel: VideoPreviewViewModel = .init()
        
        // 저장된 난이도가 있는지 확인
        var grade: SavedGrade?
        var cragId: Int?
        
        // 저장된 스토리가 있는지 확인
        var count: Int = 0
        
        var showSelectGradeView = false
        
        var grades: [Grade] = []
        var selectedGrade: DesignGrade?
        var doNotSaveGrade = false
        
        // 폴더 및 종료 바텀시트
        var showProblemCheckCompleteBottomSheet = false
        var problemCheckCompleteBottomSheetState: ProblemCheckCompleteBottomSheetFeature.State?
        
        var showFolderBottomSheet = false
        var problemCheckState: ProblemCheckFeature.State?
        
        // 권한 알럿
        @Presents var alert: AlertState<Action.Dialog>?
        
        public init() {}
    }
    
    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        
        case updateViewState(ViewState)
        
        // 탭바가 클릭 되는 경우 해당 index가 전달
        case selectedTab(Int)
        
        case onStartSession
        
        case onStopSession
        
        // Video 화면에서 촬영 버튼을 클릭시 전달
        case onStartRecord
        
        // 스토리 종료
        case endedStoryTapped
        
        // 폴더 버튼
        case folderTapped
        
        // 다음 문제
        case nextProblemTapped
        
        // 다음 문제 백그라운드 뷰 선택
        case backgroundViewTapped
        
        case selectNextGrade(grade: DesignGrade?)
        
        // 난이도 정보 조회
        case fetchedGrade(grades: [Grade])
        
        case problemCheckCompleteBottomSheetAction(ProblemCheckCompleteBottomSheetFeature.Action)
        case problemCheckAction(ProblemCheckFeature.Action)
        case recordCompleted(Int?)
        
        case registerProblemSuccess(Int)
        
        // 권한 알럿
        case showAlert
        case alert(PresentationAction<Dialog>)
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
        }
    }
    
    public enum ViewState {
        // 아직 권한을 체크하지 않는 상태
        case normal
        // 카메라이 없는 상태
        case noneVideoPermission
        // 카메라 권한이 있는 상태
        case video
    }
    
    public init(permission: PermissionHandler) {
        self.permission = permission
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        
        Reduce(videoCore)
            .ifLet(\.problemCheckCompleteBottomSheetState, action: \.problemCheckCompleteBottomSheetAction) {
                ProblemCheckCompleteBottomSheetFeature()
            }
            .ifLet(\.problemCheckState, action: \.problemCheckAction) {
                ProblemCheckFeature()
            }
            .ifLet(\.$alert, action: \.alert)
    }
}

private extension VideoFeature {
    
    func videoCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .binding(_):
            return .none
            
        case .onAppear:
            state.count = videoDataManager.getCount()
            state.grade = videoDataManager.getSavedGrade()
            state.cragId = videoDataManager.getCragId()
            
            return .run { [permission] send in
                do {
                    try await permission.requestPermission()
                    await send(.updateViewState(.video))
                    
                    // 저장된 암장 Id 있는 경우 난이도 업데이트
                    if let cragId = videoDataManager.getCragId() {
                        // TODO: 오류처리
                        let grades = try? await gradeUseCase.getCragGrades(cragId: cragId)
                        await send(.fetchedGrade(grades: grades ?? []))
                    }
                } catch {
                    await send(.updateViewState(.noneVideoPermission))
                }
            }
            
        case .updateViewState(let viewState):
            state.viewState = viewState
            if case .noneVideoPermission = viewState {
                return .send(.showAlert)
            }
            return .none
            
        case .onStartSession:
            state.count = videoDataManager.getCount()
            state.cameraModel.startSession()
            return .none
            
        case .onStopSession:
            state.cameraModel.stopSession()
            return .none
            
        case .onStartRecord:
            return .merge(
                .send(.onStopSession)
            )
            
        case .selectedTab(let index):
            guard state.viewState == .video else {
                state.cameraModel.stopSession()
                return .none
            }
            index == 1 ? state.cameraModel.startSession() : state.cameraModel.stopSession()
            return .none
            
        case .endedStoryTapped:
            guard let storyId = videoDataManager.getSavedStory()?.storyId else { return .none }
            state.showProblemCheckCompleteBottomSheet = true
            state.problemCheckCompleteBottomSheetState = .init(storyId: storyId)
            return .none
            
        case .folderTapped:
            guard let storyId = videoDataManager.getSavedStory()?.storyId else { return .none }
            state.showFolderBottomSheet = true
            state.problemCheckState = .init(storyId: storyId)
            return .none
            
        case .nextProblemTapped:
            state.showSelectGradeView = true
            state.selectedGrade = nil
            guard state.cragId != videoDataManager.getCragId() else {
                return .none
            }
            
            guard let cragId = videoDataManager.getCragId() else {
                // 저장된 암장이 없는 경우, 난이도 선택 불가능
                // 바로 영상 편집
                return .none
            }
            return .run { send in
                do {
                    let grades = try await gradeUseCase.getCragGrades(cragId: cragId)
                    await send(.fetchedGrade(grades: grades))
                } catch {
                    // 에러 처리
                    await send(.fetchedGrade(grades: []))
                }
            }
        case .backgroundViewTapped:
            state.showSelectGradeView = false
            return .none
            
        case .fetchedGrade(let grades):
            state.grades = grades
            
            if let previousGradeId = videoDataManager.getSavedGrade()?.id {
                let currentGrade = grades.first(where: { $0.id == previousGradeId })
                    .map { SavedGrade(id: $0.id, name: $0.name, hexCode: $0.hexCode) }
                videoDataManager.saveGrade(currentGrade)
            } else {
                // 저장된 난이도 정보가 없는 경우 난이도 정보 없음으로 초기화
                videoDataManager.saveGrade(nil)
                state.selectedGrade = nil
            }
            return .none
            
        case .selectNextGrade(let designGrade):
            state.showSelectGradeView = false
            let grade = state.grades.first(where: { $0.id == designGrade?.id })
            if let grade {
                let savedGrade = SavedGrade(
                    id: grade.id,
                    name: grade.name,
                    hexCode: grade.hexCode
                )
                state.grade = savedGrade
                videoDataManager.saveGrade(savedGrade)
            } else {
                state.grade = nil
                videoDataManager.saveGrade(nil)
            }
            state.selectedGrade = designGrade
            state.doNotSaveGrade = false
            return registerProblem(gradeId: grade?.id)
            
        case .problemCheckCompleteBottomSheetAction(let action):
            return problemCheckCompleteBottomSheetCore(&state, action)
            
        case .recordCompleted:
            return .none
            
        case .problemCheckAction(let action):
            return problemCheckCore(&state, action)
            
        case .registerProblemSuccess(let problemId):
            videoDataManager.changeProblemId(problemId)
            return .none
            
        case .showAlert:
            state.alert = AlertState {
                TextState("영상을 촬영하기 위해서\n아래 권한이 필요합니다.")
            } actions: {
                ButtonState(action: .confirm) {
                    TextState("설정으로")
                }
            } message: {
                TextState("사진첩, 카메라, 마이크")
            }
            return .none
            
        case .alert(.presented(.confirm)):
            if let url = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(url)
            }
            return .none
        default:
            return .none
        }
    }
    
    func problemCheckCompleteBottomSheetCore(
        _ state: inout State,
        _ action: ProblemCheckCompleteBottomSheetFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .finishTapped:
            guard let storyId = videoDataManager.getSavedStory()?.storyId else { return .none }
            videoDataManager.clear()
            state.showProblemCheckCompleteBottomSheet = false
            state.count = 0
            return .merge(
                .send(.recordCompleted(storyId)),
                updateStoryStatus(storyId: storyId)
            )
        default:
            return .none
        }
    }
    
    func problemCheckCore(
        _ state: inout State,
        _ action: ProblemCheckFeature.Action
    ) -> Effect<Action> {
        switch action {
        case .deleteSuccess:
            videoDataManager.decrementCount()
            state.count = videoDataManager.getCount()
            
            if state.count == 0 {
                state.showFolderBottomSheet = false
                videoDataManager.clear()
                return .send(.recordCompleted(nil))
            }
            return .none
        default:
            return .none
        }
    }
    
    private func registerProblem(gradeId: Int?) -> Effect<Action> {
        .run { send in
            guard let storyId = videoDataManager.getSavedStory()?.storyId else {
                return
            }
            let id = try await registerProblemUseCase.execute(storyId: storyId, gradeId: gradeId)
            await send(.registerProblemSuccess(id))
        }
    }
    
    private func updateStoryStatus(storyId: Int) -> Effect<Action> {
        .run { send in
            do {
                try await updateStoryStatusUseCase.execute(storyId)
            } catch {
                print("updateStoryStatus Error: \(error)")
            }
        }
    }
}

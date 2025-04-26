//
//  RecordedFeature.swift
//  VideoFeature
//
//  Created by saeng lin on 3/15/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import AVFoundation
import VideoFeatureInterface

import DesignKit
import VideoDomain
import EditDomain
import Domain
import Shared

import ComposableArchitecture
import UIKit

@Reducer
public struct RecordedFeature {
    
    @Dependency(\.videoUseCase) var videoUseCase
    @Dependency(\.saveStoryUseCase) var saveStoryUseCase
    @Dependency(\.saveAttemptUseCase) private var saveAttemptUseCase
    @Dependency(\.nearByCragUseCase) private var cragUseCase
    @Dependency(\.gradeUseCase) private var gradeUseCase
    @Dependency(\.videoDataManager) private var videoDataManager
    @Dependency(\.locationFetcher) private var locationFetcher
    
    @ObservableState
    public struct State: Equatable {
        
        @Presents var alert: AlertState<Action.Dialog>?
        @Presents var cragAlert: AlertState<Action.Dialog>?
        
        let fileName: String
        var path: URL
        var duration: String = ""
        var totalDuration: Double = 0
        let viewModel: RecordedPlayViewModel
        var progress: CGFloat = .zero
        var stampTimeList: [Double] = []
        
        var image: UIImage?
        
        var climbingResult: AttemptStatus = .success
        
        var selectedDesignCrag: DesignCrag?
        
        var grades: [Grade] = []
        
        // bottomSheet
        var showSelectCragBottomSheet = false
        var designCrags: [DesignCrag] = []
        
        var showSelectCragDifficultyBottomSheet = false
        
        // loading
        var isLoading: Bool = false
        
        public init(fileName: String, path: URL) {
            self.fileName = fileName.replacingOccurrences(of: ".mov", with: "")
            self.path = path
            self.viewModel = RecordedPlayViewModel(videoURL: path)
        }
    }
    
    public enum Action: BindableAction {
        
        // life cycle
        case onAppear
        case upload(type: UploadType, image: UIImage)
        
        // recordCore
        case startListeningPlayTime
        case startListeningEndPlay
        case timerTicked(CMTime, CMTime)
        case play
        case pause
        case closeButtonTapped
        case updateVideo(Video)
        case seek(Double)
        
        // navigationCore
        case editButtonTapped
        case moveEditRecord(URL, [Double])
        case close
        
        // savebuttonCore
        case successTapped
        case failureTapped
        
        // alertCore
        case alert(PresentationAction<Dialog>)
        case cragAlert(PresentationAction<Dialog>)
        case binding(BindingAction<State>)
        
        // cragBottomSheetCore
        case fetchCrags
        case fetchedCrags(_ crags: [Crag])
        case fetchedMoreCrags(_ crags: [Crag])
        case fetchGrades(cragId: Int)
        case loadMoreCrags
        
        case cragBottomSheetAction(Bool)
        case cragNameSkipButtonTapped
        case cragName(keyWord: String)
        case cragSaveButtonTapped(DesignCrag)
        
        case gradeBottomSheetShow(_ grades: [Grade])
        case gradeSaveButtonTapped(DesignGrade?)
        case gradeTapCragTitleButton
        
        // Save Story
        case saveSuccess
        case saveFailure(Error)
        
        case changeLoadingState(Bool)
        
        @CasePathable
        public enum Dialog: Equatable {
            case confirm
            case cancel
        }
        
        public enum UploadType: Equatable {
            case success
            case failture
        }
    }
    
    public var body: some ReducerOf<Self> {
        BindingReducer()
        Reduce(recordedCore)
            .ifLet(\.alert, action: \.alert)
            .ifLet(\.cragAlert, action: \.cragAlert)
    }
    
}

extension RecordedFeature {
    
    private func recordedCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        
        switch action {
        case .onAppear:
            return .merge(
                // 영상 시작
                .send(.play),
                // 타이머 시작
                .send(.startListeningPlayTime),
                // 영상 end 이벤트
                .send(.startListeningEndPlay),
                // 근처 암장 정보 조회
                .send(.fetchCrags)
            )
        
        case .binding(let action):
            return .none
            
        case .upload(type: let type, image: let image):
            return .none
        case .play, .pause, .startListeningPlayTime, .startListeningEndPlay, .timerTicked, .updateVideo, .seek:
            return recordCore(&state, action)
            
        case .closeButtonTapped, .editButtonTapped, .moveEditRecord, .close:
            return navigationCore(&state, action)
            
        case .successTapped, .failureTapped:
            return saveButtonCore(&state, action)
            
        case .alert, .cragAlert:
            return alertCore(&state, action)
            
        case .cragBottomSheetAction, .cragSaveButtonTapped, .cragNameSkipButtonTapped, .cragName, .gradeBottomSheetShow, .gradeSaveButtonTapped, .gradeTapCragTitleButton:
            return cragBottomSheetCore(&state, action)
        
        // 암장정보 조회 및 저장
        case .fetchCrags:
            return .none
            
        case .fetchedCrags(let crags):
            state.designCrags = crags.map {
                DesignCrag(id: $0.id, name: $0.name, address: $0.address)
            }
            state.showSelectCragBottomSheet = true
            return .none
        case .fetchedMoreCrags(let crags):
            let newCrags = crags.map {
                DesignCrag(id: $0.id, name: $0.name, address: $0.address)
            }
            state.designCrags.append(contentsOf: newCrags)
            return .none
            
        // 선택된 암장 정보 기반 난이도 조회
        case .fetchGrades(let selectedCragId):
            return fetchCragGrade(cragId: selectedCragId)
            
        case .loadMoreCrags:
            return fetchMoreNearByCrags()
            
        case .changeLoadingState(let isLoading):
            state.isLoading = isLoading
            return .none
            
        default:
            return .none
        }
    }
    
    private func recordCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .play:
            // 영상 시작
            state.viewModel.play()
            return .none
        case .pause:
            // 영상 정지
            state.viewModel.pause()
            return .none
        case .startListeningPlayTime:
            // 타이머 시작
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await (playTime, totalduration) in viewModel.playTimeAsyncStream {
                    await send(.timerTicked(playTime, totalduration))
                }
            }
        case .startListeningEndPlay:
            // 영상 end 이벤트
            return .run { [weak viewModel = state.viewModel] send in
                guard let viewModel else { return }
                for await _ in viewModel.playEndAsyncStream {
                    _ = await viewModel.seek(.zero)
                    viewModel.play()
                }
            }
            
        case .timerTicked(let playTime, let duration):
            // 영상 시간 표시 및 progress
            let totalTime = Double(CMTimeGetSeconds(duration))
            let currentTime = Double(CMTimeGetSeconds(playTime))
            state.duration = playTime.formatTimeInterval()

            state.progress = currentTime/totalTime
            if state.totalDuration == 0, !totalTime.isNaN {
                state.totalDuration = totalTime * 1000
            }
            return .none
        case .updateVideo(let video):
            state.totalDuration = 0
            state.viewModel.updateVideoUrl(videoURL: video.videoUrl)
            state.path = video.videoUrl
            state.stampTimeList = video.stampTimeList
            return .merge(
                .send(.play),
                .send(.startListeningPlayTime),
                .send(.startListeningEndPlay)
            )
        case .seek(let time):
            return .run { [weak viewModel = state.viewModel] _ in
                guard let viewModel else { return }
                await viewModel.seek(CMTime(seconds: time, preferredTimescale: 600))
                viewModel.play()
            }
        default:
            return .none
        }
    }
    
    private func navigationCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .closeButtonTapped:
            // close 버튼 클릭 Action
            state.alert = AlertState {
                TextState("기록 저장 취소")
            } actions: {
                ButtonState(action: .confirm) {
                    TextState("저장 안함")
                }
                
                ButtonState(action: .cancel) {
                    TextState("계속 편집")
                }
            } message: {
                TextState("이 페이지를 나가면 촬영하신 영상이 저장되지 않아요")
            }
            return .run { send in
                await send(.pause)
            }
            
        case .editButtonTapped:
            // 편집 버튼 클릭 Action
            return .merge(
                .send(.moveEditRecord(state.path, state.stampTimeList)),
                .send(.pause)
            )
            
            
        case .close:
            // 화면 닫힘
            return .none
        default:
            return .none
        }
    }
    
    private func saveButtonCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .successTapped:
            // 성공하기로 저장 버튼 클릭
            state.climbingResult = .success
            if videoDataManager.isFirstAttempt() {
                // 첫 시도
                state.showSelectCragBottomSheet = true
                return .run { send in
                    await send(.pause)
                    await send(.cragName(keyWord: ""))
                }
            } else {
                // 이후 시도
                guard !state.isLoading else { return . none }
                return .merge(
                    .send(.pause),
                    registerAttempts(state),
                    .send(.changeLoadingState(true))
                )
            }
            
        case .failureTapped:
            // 실패하기로 저장 버튼 클릭
            state.climbingResult = .failure
            if videoDataManager.isFirstAttempt() {
                // 첫 시도
                state.showSelectCragBottomSheet = true
                return .run { send in
                    await send(.pause)
                    await send(.cragName(keyWord: ""))
                }
            } else {
                // 이후 시도
                guard !state.isLoading else { return . none }
                return .merge(
                    .send(.pause),
                    registerAttempts(state),
                    .send(.changeLoadingState(true))
                )
            }
            
        default:
            return .none
        }
    }
    
    private func alertCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .alert(.presented(.confirm)):
            // close 다이얼로그  저장안함
            return .send(.close)
            
        case .alert(.presented(.cancel)):
            // close 다이얼로그  계속 편집
            return .none
            
        case .alert(.dismiss):
            // close 다이얼로그 닫힘
            return .none
            
        case .cragAlert(.presented(.confirm)):
            state.showSelectCragDifficultyBottomSheet = true
            // 암장정보 건너뛰기 alert - 저장안함
            return .none
            
        case .cragAlert(.presented(.cancel)):
            // 암장정보 건너뛰기 alert - 계속 편집
            state.showSelectCragBottomSheet = true
            return .none
            
        case .cragAlert(.dismiss):
            // 암장정보 건너뛰기 alert - 닫힘
            return .none
            
        default:
            return .none
        }
    }
    
    private func cragBottomSheetCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        switch action {
        case .cragBottomSheetAction(let isPresent):
            // 암장 선택 바텀시트 - present newValue
            state.showSelectCragBottomSheet = isPresent
            return .none
            
        case .cragSaveButtonTapped(let designCrag):
            // 암장 선택 바텀시트 - 저장버튼 클릭
            videoDataManager.saveCragId(designCrag.id)
            state.showSelectCragBottomSheet = false
            
            state.selectedDesignCrag = designCrag
            return fetchCragGrade(cragId: designCrag.id)
            
        case .cragNameSkipButtonTapped:
            // 암장 선택 바텀시트 - 스킵 버튼 클릭
            state.showSelectCragBottomSheet = false
            state.cragAlert = AlertState {
                TextState("암장 정보 입력 건너뛰기")
            } actions: {
                ButtonState(action: .cancel) {
                    TextState("계속 편집")
                }
                ButtonState(action: .confirm) {
                    TextState("저장 안함")
                }
            } message: {
                TextState("임장 입력을 하지 않으면 기록은 가능하지만,\n암장 관련 정보는 저장되지 않아요")
            }
            return .none
            
        case .cragName(let keyword):
            // 암장 등급을 검색할떄 호출
            return fetchNearByCrags(keyword: keyword)
            
        case .gradeBottomSheetShow(let grades):
            // 암장 등급을 보여주기 위해서 호출되는 값
            state.grades = grades
            state.showSelectCragDifficultyBottomSheet = true
            return .none
            
        case .gradeTapCragTitleButton:
            // 암장 등급 바텀시트
            return .none
            
        case .gradeSaveButtonTapped(let designGrade):
            // 로딩 중 연속 터치 방지
            guard !state.isLoading else { return .none }
            
            // 암장 등급 바텀시트에서 등급을 저장하기 버튼을 누르면 오는 이벤트
            print("최종 저장 시간 : \(state.totalDuration)")
            saveSelectedGrade(grades: state.grades, selectedGrade: designGrade)
            state.showSelectCragDifficultyBottomSheet = false
            return .merge(
                registerStory(state),
                .send(.changeLoadingState(true))
                )
            
        case .saveSuccess:
            state.isLoading = false
            return .none
            
        case .saveFailure(let error):
            print("error: \(error)")
            state.showSelectCragDifficultyBottomSheet = true
            return .send(.changeLoadingState(false))
        default: return .none
        }
    }
    
    private func gradeBttomSheetCore(
        _ state: inout State,
        _ action: Action
    ) -> Effect<Action> {
        return .none
    }
    
    private func fetchNearByCrags(keyword: String) -> Effect<Action> {
        let locationFetcher = locationFetcher
        return .run { [locationFetcher] send in
            do {
                let location = try? await locationFetcher.fetchCurrentLocation()
                let crags = try await cragUseCase.fetch(keyword: keyword, location: location)
                await send(.fetchedCrags(crags))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchCragGrade(cragId: Int) -> Effect<Action> {
        .run { send in
            do {
                let grades = try await gradeUseCase.getCragGrades(cragId: cragId)
                await send(.gradeBottomSheetShow(grades))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func fetchMoreNearByCrags() -> Effect<Action> {
        return .run { send in
            do {
                let crags = try await cragUseCase.next()
                await send(.fetchedMoreCrags(crags))
            } catch {
                debugPrint(error.localizedDescription)
            }
        }
    }
    
    private func saveSelectedGrade(grades: [Grade], selectedGrade: DesignGrade?) {
        let grade = grades.first(where: { $0.id == selectedGrade?.id })
        if let grade {
            videoDataManager.saveGrade(
                SavedGrade(
                    id: grade.id,
                    name: grade.name,
                    hexCode: grade.hexCode
                )
            )
        } else {
            videoDataManager.saveStory(nil)
        }
    }
    
    /// 시도 저장
    private func registerAttempts(_ state: State) -> Effect<Action> {
        return .run { send in
            guard let story = videoDataManager.getSavedStory() else { return }
            
            let thumbNailImage = try await generateImage(path: state.path, totalDuration: Int(state.totalDuration))
            
            let thumbNailUrl = try? await videoUseCase.execute(
                fileName: "\(state.fileName).png",
                mimeType: "image/png",
                value: thumbNailImage
            )
            
            let assetId = try await videoUseCase.execute(saveFile: state.path)
            
            print("✅ thumbnailURL: \(thumbNailUrl)")
            
            let request = AttemptRequest(
                status: state.climbingResult,
                problemId: story.problemId,
                video: VideoRequest(
                    localPath: assetId,
                    thumbnailUrl: thumbNailUrl,
                    durationMs: Int(state.totalDuration),
                    stamps: state.stampTimeList.map { StampRequest(timeMs: Int($0 * 1000)) }
                )
            )
            
            do {
                try await saveAttemptUseCase.register(request)
                videoDataManager.incrementCount()
                await send(.saveSuccess)
            } catch {
                await send(.saveFailure(error))
            }
        }
    }
    
    /// 최초 스토리 저장
    private func registerStory(_ state: State) -> Effect<Action> {
        return .run { [videoDataManager] send in
            let thumbNailImage = try await generateImage(path: state.path, totalDuration: Int(state.totalDuration))
            
            let thumbNailUrl = try? await videoUseCase.execute(
                fileName: "\(state.fileName).png",
                mimeType: "image/png",
                value: thumbNailImage
            )
            
            let assetId = try await videoUseCase.execute(saveFile: state.path)
            let grade = videoDataManager.getSavedGrade()
            let request = StoryRequest(
                cragId: state.selectedDesignCrag?.id,
                problem: ProblemRequest(gradeId: grade?.id), // 난이도 ID
                attempt: AttemptRequest(
                    status: state.climbingResult,
                    problemId: nil,
                    video: VideoRequest(
                        localPath: assetId,
                        thumbnailUrl: thumbNailUrl,
                        durationMs: Int(state.totalDuration),
                        stamps: state.stampTimeList.map { StampRequest(timeMs: Int($0 * 1000)) }
                    )
                ),
                memo: nil
            )
            
            do {
                let response = try await saveStoryUseCase.execute(request)
                videoDataManager.saveStory(response)
                videoDataManager.incrementCount()
                await send(.saveSuccess)
            } catch {
                await send(.saveFailure(error))
            }
        }
    }
    
    private func generateImage(path: URL, totalDuration: Int) async throws -> Data {
        let generator = AVAssetImageGenerator(asset: AVAsset(url: path))
        generator.appliesPreferredTrackTransform = true
        let cmTime = CMTime(seconds: Double((totalDuration / 1_000) / 2), preferredTimescale: 600)
        do {
            let thumbnail = try await generator.image(at: cmTime)
            guard let resizeImage = UIImage(cgImage: thumbnail.image).resizedPNGData() else {
                throw VideoError.unknown
            }
            return resizeImage
        } catch {
            throw VideoError.unknown
        }
    }
}

extension UIImage {
    func resizedPNGData(targetSizeInBytes: Int = 1_000_000) -> Data? {
        guard var currentData = self.pngData() else { return nil }
        
        // 이미지의 해상도를 줄여서 targetSizeInBytes 미만이 될 때까지 반복
        var currentImage = self
        let scaleFactor: CGFloat = 0.9
        
        while currentData.count > targetSizeInBytes,
              currentImage.size.width > 100, currentImage.size.height > 100 {
            let newSize = CGSize(width: currentImage.size.width * scaleFactor,
                                 height: currentImage.size.height * scaleFactor)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
            currentImage.draw(in: CGRect(origin: .zero, size: newSize))
            guard let resizedImage = UIGraphicsGetImageFromCurrentImageContext() else {
                UIGraphicsEndImageContext()
                break
            }
            UIGraphicsEndImageContext()
            
            currentImage = resizedImage
            if let data = currentImage.pngData() {
                currentData = data
            } else {
                break
            }
        }
        
        return currentData.count <= targetSizeInBytes ? currentData : nil
    }
}

//
//  ClogServiceAssembly.swift
//  ClogService
//
//  Created by Junyoung on 3/2/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation

import Core
import Data
import Domain
import AccountDomain
import FolderDomain
import CalendarDomain
import VideoDomain
import StoryDomain
import Networker
import Swinject
import AccountDomain
import ReportDomain

import VideoFeatureInterface
import VideoFeature

public struct ClogServiceAssembly: Assembly {
    public init() {}
    
    public func assemble(container: Container) {
        
        container.register(LocationFetcher.self) { _ in
            DefaultLocationFetcher()
        }

        container.register(LoginUseCase.self) { _ in
            DefaultLoginUseCase(
                repository: DefaultLoginRepository(
                    authDataSource: DefaultAuthDataSource(),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(FutureMonthCheckerUseCase.self) { _ in
            FutureMonthChecker()
        }
        
        container.register(FetchCalendarUseCase.self) { _ in
            FetchCalendar(
                repository: DefaultCalendarRepository(
                    dataSource: DefaultCalendarDataSource()
                )
            )
        }
        
        container.register(FetchStoryUseCase.self) { _ in
            FetchStory(
                repository: DefaultStoryRepository(
                    dataSource: DefaultStoriesDataSource()
                )
            )
        }
        
        container.register(FilteredAttemptsUseCase.self) { _ in
            DefaultFilteredAttemptsUseCase(
                attemptRepository: DefaultAttemptRepository(
                    dataSource: DefaultAttemptDataSource()
                )
            )
        }
        
        container.register(FetchFilterableAttemptInfoUseCase.self) { resolver in
            DefaultFetchFilterableAttemptInfoUseCase(
                gradeRepository: DefaultGradeRepository(
                    dataSource: DefaultGradeDataSource()
                ),
                cragRepository: DefaultCragRepository(
                    dataSource: DefaultCragDataSource()
                )
            )
        }
        
        container.register(LogoutUseCase.self) { _ in
            Logout(
                repository: DefaultLogoutRepository(
                    userDataSource: DefaultUserDataSource(),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(WithdrawUseCase.self) { _ in
            Withdraw(
                repository: DefaultWithdrawRepository(
                    userDataSource: DefaultUserDataSource(),
                    tokenDataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(LoginTypeFetcherUseCase.self) { _ in
            LoginTypeFetcher(
                repository: DefaultTokenRepository(
                    dataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(ValidateUserSessionUseCase.self) { _ in
            ValidateUserSession(
                repository: DefaultTokenRepository(
                    dataSource: DefaultTokenDataSource()
                )
            )
        }
        
        container.register(AttemptUseCase.self) { _ in
            DefaultAttemptUseCase(
                attemptRepository: DefaultAttemptRepository(
                    dataSource: DefaultAttemptDataSource()
                )
            )
        }
        
        container.register(EditMemoUseCase.self) { _ in
            EditMemo(
                repository: DefaultEditMemoRepository(
                    dataSource: DefaultStoriesDataSource()
                )
            )
        }
        
        container.register(DeleteStoryUseCase.self) { _ in
            DeleteStory(
                repository: DefaultDeleteStoryRepository(
                    dataSource: DefaultStoriesDataSource()
                )
            )
        }
        
        container.register(ReportFetcherUseCase.self) { _ in
            ReportFetcher(
                repository: DefaultReportRepository(
                    dataSource: DefaultReportDataSource()
                )
            )
        }
        
        container.register(NearByCragUseCase.self) { _ in
            DefaultNearByCragUseCase(
                repository: DefaultNearByCragRepository(
                    dataSource: DefaultCragDataSource()
                )
            )
        }
        
        container.register(GradeUseCase.self) { _ in
            DefaultGradeUseCase(
                gradeRepository: DefaultGradeRepository(
                    dataSource: DefaultGradeDataSource()
                )
            )
        }
        container.register(VideoRepository.self) { resolver in
            VideoRecordRepository(
                dataSource: VideoDataSource()
            )
        }
        
        container.register(SaveStoryUseCase.self) { _ in
            SaveStory(
                repository: DefaultSaveStoryRepository(
                    dataSource: DefaultStoriesDataSource()
                )
            )
        }
        
        container.register(SaveAttemptUseCase.self) { _ in
            SaveAttempt(
                repository: DefaultSaveAttemptRepository(
                    dataSource: DefaultAttemptDataSource()
                )
            )
        }
        
        container.register(AccountUseCase.self) { _ in
            Account(
                repository: DefaultAccountRepository(
                    dataSource: DefaultUserDataSource()
                )
            )
        }
        
        container.register(RegisterProblemUseCase.self) { _ in
            RegisterProblem(
                repository: DefaultProblemRepository(
                    dataSource: DefaultStoriesDataSource()
                )
            )
        }
        
        container.register(UpdateStoryStatusUseCase.self) { _ in
            UpdateStoryStatus(
                repository: DefaultStoryRepository(
                    dataSource: DefaultStoriesDataSource()
                )
            )
        }
        
        container.register(VideoDataManager.self) { _ in
            LocalVideoDataManager()
        }
    }
}

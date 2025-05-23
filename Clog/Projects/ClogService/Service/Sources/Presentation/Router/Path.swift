//
//  Path.swift
//  ClogService
//
//  Created by Junyoung Lee on 3/18/25.
//  Copyright © 2025 Supershy. All rights reserved.
//

import Foundation
import ComposableArchitecture
import CalendarFeature
import SettingFeature
import FolderFeature
import CompletionReportFeature
import AddAttemptsFeature
import Core

@Reducer
public enum Path {
    case calendarDetail(CalendarDetailFeature)
    case setting(SettingFeature)
    case webView(WebViewFeature)
    case attempt(AttemptFeature)
    case addAttempts(AddAttemptsFeature)
    case completionReport(CompletionReportFeature)
}

//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/24/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .service(name: "Clog"),
    product: .staticFramework,
    dependencies: [
        .Features.CompletionReport.feature,
        .Features.NickName.feature,
        .Features.Onboarding.feature,
        .Features.Splash.feature,
        .Features.Report.feature,
        .Features.Setting.feature,
        .Features.Edit.feature,
        .Features.Calendar.feature,
        .Features.Folder.feature,
        .Features.FolderTab.feature,
        .Features.Video.feature,
        .Features.Login.feature,
        .Features.Main.feature,
        .Data.data(.clog)
    ]
)

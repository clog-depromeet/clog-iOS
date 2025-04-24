//
//  Project.swift
//  Config
//
//  Created by Junyoung on 1/9/25.
//

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "Shared"),
    product: .framework,
    dependencies: [
        .Modules.thirdPartyLibrary(.clog)
    ]
)

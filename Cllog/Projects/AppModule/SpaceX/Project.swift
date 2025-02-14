//
//  Project.swift
//  Config
//
//  Created by saeng lin on 1/27/25.
//

import Foundation

@preconcurrency import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .module(name: "SpaceX"),
    product: .staticFramework,
    dependencies: [
        .Library.alamofire
    ]
)

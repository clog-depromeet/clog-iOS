//
//  Workspace.swift
//  TestProjectManifests
//
//  Created by Junyoung on 1/8/25.
//

@preconcurrency import ProjectDescription

let workspace = Workspace(
    name: "Clog",
    projects: [
        "Projects/**"
    ]
)


//
//  service.swift
//  Config
//
//  Created by Junyoung on 1/24/25.
//

import ProjectDescription

let nameAttribute: Template.Attribute = .required("name")
let serviceAttribute: Template.Attribute = .required("service")

let template = Template(
    description: "Domain module template",
    attributes: [
        nameAttribute,
        serviceAttribute
    ],
    items: [
        // MARK: Project
        .file(path: "\(nameAttribute)Domain/Project.swift",
              templatePath: "../stencil/domainProject.stencil"),
        
        // MARK: Sources
        .file(path: "\(nameAttribute)Domain/Sources/Sample.swift",
              templatePath: "../stencil/sample.stencil"),
        
        // MARK: Tests
        .file(path: "\(nameAttribute)Domain/Tests/Sources/Sample.swift",
              templatePath: "../stencil/sample.stencil"),
    ]
)


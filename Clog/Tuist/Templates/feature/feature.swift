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
    description: "Feature module template",
    attributes: [
        nameAttribute,
        serviceAttribute
    ],
    items: [
        // MARK: Project
        .file(path: "\(nameAttribute)Feature/Project.swift",
              templatePath: "../stencil/featureProject.stencil"),
        
        // MARK: Sources
        .file(path: "\(nameAttribute)Feature/Sources/Sample.swift",
              templatePath: "../stencil/sample.stencil"),
        
        // MARK: Tests
        .file(path: "\(nameAttribute)Feature/Tests/Sources/Sample.swift",
              templatePath: "../stencil/sample.stencil"),
        
        // MARK: Test
        .file(path: "\(nameAttribute)Feature/Test/Sources/Sample.swift",
              templatePath: "../stencil/sample.stencil"),
        
        // MARK: Demo
        .file(path: "\(nameAttribute)Feature/Demo/Resources/Sample.swift",
              templatePath: "../stencil/sample.stencil"),
        .file(path: "\(nameAttribute)Feature/Demo/Sources/AppDelegate.swift",
              templatePath: "../stencil/appDelegate.stencil"),
        .file(path: "\(nameAttribute)Feature/Demo/Sources/App.swift",
              templatePath: "../stencil/app.stencil"),
        
        // MARK: Interface
        .file(path: "\(nameAttribute)Feature/Interface/Sources/Sample.swift",
              templatePath: "../stencil/sample.stencil")
    ]
)

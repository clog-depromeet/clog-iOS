import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Folder"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

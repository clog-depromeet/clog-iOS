import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Story"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

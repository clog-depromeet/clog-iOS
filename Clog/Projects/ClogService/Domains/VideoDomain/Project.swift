import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Video"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

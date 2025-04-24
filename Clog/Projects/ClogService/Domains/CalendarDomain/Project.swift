import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Calendar"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Edit"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

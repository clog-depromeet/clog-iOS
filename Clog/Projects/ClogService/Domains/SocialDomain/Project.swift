import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Social"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

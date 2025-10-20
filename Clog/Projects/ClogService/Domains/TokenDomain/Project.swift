import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Token"),
    product: .staticFramework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

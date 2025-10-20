import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Account"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

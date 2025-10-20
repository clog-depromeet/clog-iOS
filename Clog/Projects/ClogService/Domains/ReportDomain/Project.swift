import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .domain(name: "Report"),
    product: .framework,
    dependencies: [
        .Modules.shared(.clog)
    ]
)

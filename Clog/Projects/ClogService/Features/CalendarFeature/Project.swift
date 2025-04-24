import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .feature(name: "Calendar", type: .micro),
    product: .staticFramework,
    dependencies: [
        .Core.core(.clog)
    ]
)

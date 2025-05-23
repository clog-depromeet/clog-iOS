import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .feature(name: "ProfileEditor", type: .micro),
    product: .staticFramework,
    dependencies: [
        .Core.core(.clog)
    ]
)

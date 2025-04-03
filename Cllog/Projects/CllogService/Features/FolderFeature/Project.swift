import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .feature(name: "Folder", type: .micro),
    product: .staticFramework,
    dependencies: [
        .Core.core(.cllog),
    ]
)

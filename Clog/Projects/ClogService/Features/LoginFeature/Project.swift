import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.configure(
    moduleType: .feature(name: "Login", type: .micro),
    product: .staticFramework,
    dependencies: [
        .Core.core(.clog),
        .Library.KakaoSDKUser,
    ]
)

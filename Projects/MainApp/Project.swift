import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Gist",
    organizationName: "Willian Policiano",
    targets: [
        Target(
            name: "Gist",
            platform: .iOS,
            product: .app,
            bundleId: "br.com.policiano.Gist",
            infoPlist: "Resources/Info.plist",
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            dependencies: [
                .project(target: "Domain", path: .relativeToManifest("../Domain")),
                .project(target: "Presentation", path: .relativeToManifest("../Presentation")),
                .project(target: "Repository", path: .relativeToManifest("../Repository")),
                .project(target: "Utils", path: .relativeToManifest("../Utils"))
            ]
        ),
        Target(
            name: "GistTests",
            platform: .iOS,
            product: .unitTests,
            bundleId: "br.com.policiano.GistTests",
            infoPlist: "Tests/Resources/Info.plist",
            sources: ["Tests/Sources/**"],
            resources: ["Tests/Resources/**"],
            dependencies: [
                .target(name: "Gist"),
                .xctest
            ]
        )
    ]
)

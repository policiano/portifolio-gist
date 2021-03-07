import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "Repository",
    packages: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", .upToNextMajor(from: "7.7.0")),
        .package(url: "https://github.com/alickbass/CodableFirebase.git", .upToNextMajor(from: "0.2.0")),
        .package(url: "https://github.com/Moya/Moya.git", .upToNextMajor(from: "14.0.0"))
    ],
    dependencies: [
        .project(target: "Domain", path: .relativeToManifest("../Domain")),
        .project(target: "Utils", path: .relativeToManifest("../Utils")),
        .package(product: "CodableFirebase"),
        .package(product: "FirebaseDatabase"),
        .package(product: "Moya")
    ],
    testDependencies: [
        .project(target: "DomainTestUtils", path: .relativeToManifest("../Domain")),
        .project(target: "UtilsTestUtils", path: .relativeToManifest("../Utils"))
    ]
)

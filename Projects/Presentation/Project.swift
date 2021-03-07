import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "Presentation",
    resourcesFolder: true,
    packages: [
        .package(url: "https://github.com/Rightpoint/Anchorage.git", .upToNextMajor(from: "4.5.0")),
        .package(url: "https://github.com/onevcat/Kingfisher.git", .upToNextMajor(from: "5.0.0")),
        .package(url: "https://github.com/ElaWorkshop/TagListView.git", .upToNextMajor(from: "1.4.0")),
    ],
    dependencies: [
        .project(target: "Domain", path: .relativeToManifest("../Domain")),
        .project(target: "Repository", path: .relativeToManifest("../Repository")),
        .package(product: "Anchorage"),
        .package(product: "Kingfisher"),
        .package(product: "TagListView"),
        .cocoapods(path: ".")
    ],
    testDependencies: [
        .project(target: "DomainTestUtils", path: .relativeToManifest("../Domain")),
        .project(target: "RepositoryTestUtils", path: .relativeToManifest("../Repository")),
        .project(target: "Repository", path: .relativeToManifest("../Repository")),
        .project(target: "UtilsTestUtils", path: .relativeToManifest("../Utils"))
    ]
)

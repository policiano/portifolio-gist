import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.framework(
    name: "Domain",
    dependencies: [
        .project(target: "Utils", path: .relativeToManifest("../Utils"))
    ],
    testDependencies: [
        .project(target: "UtilsTestUtils", path: .relativeToManifest("../Utils"))
    ]
)

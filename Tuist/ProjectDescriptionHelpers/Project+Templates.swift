import ProjectDescription

extension Project {

    public static func app(name: String, platform: Platform, dependencies: [TargetDependency] = []) -> Project {
        return self.project(name: name, product: .app, platform: platform, packages: [], dependencies: dependencies, infoPlist: [
            "CFBundleShortVersionString": "1.0",
            "CFBundleVersion": "1"
        ])
    }

    public static func framework(name: String, platform: Platform = .iOS, packages: [Package] = [], dependencies: [TargetDependency] = [], testDependencies: [TargetDependency] = []) -> Project {
        return self.project(name: name, product: .framework, platform: platform, packages: packages, dependencies: dependencies, testDependencies: testDependencies)
    }

    public static func project(
        name: String,
        product: Product,
        platform: Platform,
        packages: [Package],
        dependencies: [TargetDependency] = [],
        infoPlist: [String: InfoPlist.Value] = [:],
        testDependencies: [TargetDependency] = []
    ) -> Project {
        return Project(
            name: name,
            packages: packages,
            targets: [
                Target(
                    name: name,
                    platform: platform,
                    product: product,
                    bundleId: "io.tuist.\(name)",
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sources/**"],
                    resources: [],
                    dependencies: dependencies
                ),
                Target(
                    name: "\(name)Tests",
                    platform: platform,
                    product: .unitTests,
                    bundleId: "io.tuist.\(name)Tests",
                    infoPlist: .default,
                    sources: "Tests/**",
                    dependencies: testDependencies + [
                        .target(name: "\(name)"),
                        .xctest
                    ]
                ),
                Target(
                    name: "\(name)TestUtils",
                    platform: platform,
                    product: .framework,
                    bundleId: "io.tuist.\(name)TestUtils",
                    infoPlist: .default,
                    sources: "Tests/Utils/**",
                    dependencies: [
                        .target(name: "\(name)"),
                    ]
                )
            ]
        )
    }

}

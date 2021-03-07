import ProjectDescription

extension Project {

    private static func bundleIdWith(name: String) -> String {
        "br.com.policiano.\(name)"
    }

    public static func app(
        name: String,
        platform: Platform,
        resourcesFolder: Bool = false,
        actions: [TargetAction] = [],
        dependencies: [TargetDependency] = []
    ) -> Project {
        self.project(
            name: name,
            product: .app,
            platform: platform,
            resourcesFolder: resourcesFolder,
            packages: [],
            actions: actions,
            dependencies: dependencies,
            infoPlist: [
                "CFBundleShortVersionString": "1.0",
                "CFBundleVersion": "1"
            ]
        )
    }

    public static func framework(
        name: String,
        platform: Platform = .iOS,
        resourcesFolder: Bool = false,
        packages: [Package] = [],
        actions: [TargetAction] = [],
        dependencies: [TargetDependency] = [],
        testDependencies: [TargetDependency] = []
    ) -> Project {
        self.project(
            name: name,
            product: .framework,
            platform: platform,
            resourcesFolder: resourcesFolder,
            packages: packages,
            actions: actions,
            dependencies: dependencies,
            testDependencies: testDependencies
        )
    }

    public static func project(
        name: String,
        product: Product,
        platform: Platform,
        resourcesFolder: Bool,
        packages: [Package],
        actions: [TargetAction],
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
                    bundleId: bundleIdWith(name: name),
                    infoPlist: .extendingDefault(with: infoPlist),
                    sources: ["Sources/**"],
                    resources: resourcesFolder ? ["Resources/**"] : [],
                    actions: actions,
                    dependencies: dependencies
                ),
                Target(
                    name: "\(name)Tests",
                    platform: platform,
                    product: .unitTests,
                    bundleId: "\(bundleIdWith(name: name))Tests",
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
                    bundleId: "\(bundleIdWith(name: name))TestUtils",
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

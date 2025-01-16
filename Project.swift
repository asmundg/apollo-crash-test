import ProjectDescription

let project = Project(
    name: "apollo-crash-test",
    targets: [
        .target(
            name: "apollo-crash-test",
            destinations: [.iPad, .iPhone],
            product: .app,
            bundleId: "io.tuist.apollo-crash-test",
                  deploymentTargets: .iOS("16.0"),
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            sources: ["apollo-crash-test/Sources/**"],
            resources: ["apollo-crash-test/Resources/**"],
            dependencies: [
              .external(name: "Apollo"),
            ]
        ),
        .target(
            name: "apollo-crash-testTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.apollo-crash-testTests",
            infoPlist: .default,
            sources: ["apollo-crash-test/Tests/**"],
            resources: [],
            dependencies: [.target(name: "apollo-crash-test")]
        ),
    ]
)

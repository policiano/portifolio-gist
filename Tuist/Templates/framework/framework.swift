import ProjectDescription
let nameAttribute: Template.Attribute = .required("name")

let exampleContents = """
import Foundation

struct \(nameAttribute) { }
"""

let testContents = """
import Foundation
import XCTest

final class \(nameAttribute)Tests: XCTestCase {

    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func test_example() {
        // Add your test here
    }

}
"""

let testUtilsContent = """
import Foundation

public final class \(nameAttribute)Dummy {

    public init() { }

}
"""

let template = Template(
    description: "Framework template",
    attributes: [
        nameAttribute,
        .optional("platform", default: "iOS")
    ],
    files: [
        .string(path: "\(nameAttribute)/Sources/\(nameAttribute).swift", contents: exampleContents),
        .string(path: "\(nameAttribute)/Tests/\(nameAttribute)Tests.swift", contents: testContents),
        .string(path: "\(nameAttribute)/Tests/Utils/\(nameAttribute)Dummy.swift", contents: testUtilsContent),
        .file(path: "\(nameAttribute)/Project.swift", templatePath: "project.stencil"),
    ]
)

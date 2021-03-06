import Foundation
import XCTest

@testable import Domain

final class GistDigestTests: XCTestCase {

    func test_fileInit_shouldAssignTheProperValues() {
        let expectedName = String.anyValue
        let expectedType = String.anyValue

        let sut = GistDigest.File(name: expectedName, type: expectedType)

        XCTAssertEqual(sut.name, expectedName)
        XCTAssertEqual(sut.type, expectedType)
    }

    func test_ownerInit_shouldAssignTheProperValues() {
        let expectedName = String.anyValue
        let expectedUrl = Optional<URL>.anyValue

        let sut = GistDigest.Owner(name: expectedName, avatarUrl: expectedUrl)

        XCTAssertEqual(sut.name, expectedName)
        XCTAssertEqual(sut.avatarUrl, expectedUrl)
    }

    func test_gistDigestInit_shouldAssignTheProperValues() {
        let expectedId = String.anyValue
        let expectedCreatedAt = String.anyValue
        let expectedFileName = String.anyValue
        let expectedFileType = String.anyValue
        let expectedOwnerName = String.anyValue
        let expectedOwnerUrl = Optional<URL>.anyValue
        let expectedDescription = String.anyValue
        let expectedSnippetPath = String.anyValue
        let expectedBookmarkedAt = Date(timeIntervalSince1970: .anyValue)
        let expectedFiles = [GistDigest.File(name: expectedFileName, type: expectedFileType)]
        let owner = GistDigest.Owner(name: expectedOwnerName, avatarUrl: expectedOwnerUrl)

        let sut = GistDigest(
            id: expectedId,
            createdAt: expectedCreatedAt,
            description: expectedDescription,
            owner: owner,
            files: expectedFiles,
            bookmarkedAt: expectedBookmarkedAt,
            snippetPath: expectedSnippetPath
        )

        XCTAssertNotNil(sut.files.first)
        XCTAssertEqual(sut.files.count, expectedFiles.count)
        XCTAssertEqual(sut.files.first?.name, expectedFileName)
        XCTAssertEqual(sut.files.first?.type, expectedFileType)
        XCTAssertEqual(sut.owner.name, expectedOwnerName)
        XCTAssertEqual(sut.owner.avatarUrl, expectedOwnerUrl)
        XCTAssertEqual(sut.description, expectedDescription)
        XCTAssertEqual(sut.id, expectedId)
        XCTAssertEqual(sut.createdAt, expectedCreatedAt)
        XCTAssertEqual(sut.bookmarkedAt, expectedBookmarkedAt)
        XCTAssertEqual(sut.snippetPath, expectedSnippetPath)
    }
}

@testable
import Gist

import XCTest

final class GistDigestResponseMapperTests: XCTestCase {

    // MARK: File

    func test_mapFileResponse_withNilFilenameAndType_shouldReturnNil() {
        let filename: String? = nil
        let type: String? = nil
        let response = GistDigestResponse.File(
            filename: filename,
            type: type
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNil(sut)
    }

    func test_mapFileResponse_withNilFilename_shouldReturnNil() {
        let filename: String? = nil
        let type: String = .anyValue
        let response = GistDigestResponse.File(
            filename: filename,
            type: type
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNil(sut)
    }

    func test_mapFileResponse_withNilType_shouldReturnNil() {
        let filename: String = .anyValue
        let type: String? = nil
        let response = GistDigestResponse.File(
            filename: filename,
            type: type
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNil(sut)
    }

    func test_mapFileResponse_withFileNameAndType_shouldReturnNil() {
        let expectedFilename: String = .anyValue
        let expectedType: String = .anyValue
        let response = GistDigestResponse.File(
            filename: expectedFilename,
            type: expectedType
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.name, expectedFilename)
        XCTAssertEqual(sut?.type, expectedType)
    }

    // MARK: Owner

    func test_mapOwnerResponse_withNilLogin_shouldReturnTheFile() {
        let login: String? = nil
        let avatarUrl: String? = .anyValue
        let response = GistDigestResponse.Owner(
            login: login,
            avatarUrl: avatarUrl
        )

        let sut = GistDigest.Owner(response: response)

        XCTAssertNil(sut)
    }

    func test_mapOwnerResponse_withLogin_shouldReturnTheOwner() {
        let login: String = .anyValue
        let avatarUrl: URL? = .anyValue
        let response = GistDigestResponse.Owner(
            login: login,
            avatarUrl: avatarUrl?.absoluteString
        )

        let sut = GistDigest.Owner(response: response)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.name, login)
        XCTAssertEqual(sut?.avatarUrl?.absoluteString, avatarUrl?.absoluteString)
    }

    // MARK: GistDigest

    func test_mapGistDigest_withouId_shouldReturnNil() {
        let avatarUrl: URL? = .anyValue

        let ownerResponse = GistDigestResponse.Owner(
            login: String.anyValue,
            avatarUrl: avatarUrl?.absoluteString
        )

        let fileResponse = GistDigestResponse.File(
            filename: String.anyValue,
            type: String.anyValue
        )

        let random = Bool.random

        let digestResponse = GistDigestResponse(
            id: nil,
            createdAt: String.anyValue,
            description: .anyValue,
            owner: random() ? ownerResponse : nil,
            files: random() ? [.anyValue: fileResponse] : [:]
        )

        let sut = GistDigest(response: digestResponse)

        XCTAssertNil(sut)
    }

    func test_mapGistDigest_withouCreatedAt_shouldReturnNil() {
        let avatarUrl: URL? = .anyValue

        let ownerResponse = GistDigestResponse.Owner(
            login: String.anyValue,
            avatarUrl: avatarUrl?.absoluteString
        )

        let fileResponse = GistDigestResponse.File(
            filename: String.anyValue,
            type: String.anyValue
        )

        let random = Bool.random

        let digestResponse = GistDigestResponse(
            id: String.anyValue,
            createdAt: nil,
            description: .anyValue,
            owner: random() ? ownerResponse : nil,
            files: random() ? [.anyValue: fileResponse] : [:]
        )

        let sut = GistDigest(response: digestResponse)

        XCTAssertNil(sut)
    }

    func test_mapGistDigest_withoutOnwer_shouldReturnNil() {
        let fileResponse = GistDigestResponse.File(
            filename: String.anyValue,
            type: String.anyValue
        )

        let digestResponse = GistDigestResponse(
            id: String.anyValue,
            createdAt: String.anyValue,
            description: .anyValue,
            owner: nil,
            files: [.anyValue: fileResponse]
        )

        let sut = GistDigest(response: digestResponse)

        XCTAssertNil(sut)
    }

    func test_mapGistDigest_withoutFiles_shouldReturnNil() {
        let avatarUrl: URL? = .anyValue

        let ownerResponse = GistDigestResponse.Owner(
            login: String.anyValue,
            avatarUrl: avatarUrl?.absoluteString
        )

        let digestResponse = GistDigestResponse(
            id: String.anyValue,
            createdAt: String.anyValue,
            description: .anyValue,
            owner: ownerResponse,
            files: [:]
        )

        let sut = GistDigest(response: digestResponse)

        XCTAssertNil(sut)
    }

    func test_mapGistDigest_withAllRequiredProperties_shouldMapProperly() {
        let avatarUrl: URL? = .anyValue

        let ownerResponse = GistDigestResponse.Owner(
            login: String.anyValue,
            avatarUrl: avatarUrl?.absoluteString
        )

        let fileResponse = GistDigestResponse.File(
            filename: String.anyValue,
            type: String.anyValue
        )

        let fileId = String.anyValue
        let digestResponse = GistDigestResponse(
            id: String.anyValue,
            createdAt: String.anyValue,
            description: .anyValue,
            owner: ownerResponse,
            files: [fileId: fileResponse]
        )

        let sut = GistDigest(response: digestResponse)

        XCTAssertNotNil(sut)
        XCTAssertEqual(sut?.id, digestResponse.id)
        XCTAssertEqual(sut?.description, digestResponse.description)
        XCTAssertEqual(sut?.owner.name, digestResponse.owner?.login)
        XCTAssertEqual(sut?.owner.avatarUrl?.absoluteString, avatarUrl?.absoluteString)
        XCTAssertEqual(sut?.files.first?.name, digestResponse.files?[fileId]?.filename)
        XCTAssertEqual(sut?.files.first?.type, digestResponse.files?[fileId]?.type)
    }
}

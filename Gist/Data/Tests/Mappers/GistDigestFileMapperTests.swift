@testable
import Gist

import XCTest

final class GistDigestFileMapperTests: XCTestCase {

    func test_mapResponse_withNilFilenameAndType_shouldReturnNil() {
        let filename: String? = nil
        let type: String? = nil
        let response = GistDigestResponse.File(
            filename: filename,
            type: type
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNil(sut)
    }

    func test_mapResponse_withNilFilename_shouldReturnNil() {
        let filename: String? = nil
        let type: String = .anyValue
        let response = GistDigestResponse.File(
            filename: filename,
            type: type
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNil(sut)
    }

    func test_mapResponse_withNilType_shouldReturnNil() {
        let filename: String = .anyValue
        let type: String? = nil
        let response = GistDigestResponse.File(
            filename: filename,
            type: type
        )

        let sut = GistDigest.File(response: response)

        XCTAssertNil(sut)
    }

    func test_mapResponse_withFileNameAndType_shouldReturnNil() {
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
}

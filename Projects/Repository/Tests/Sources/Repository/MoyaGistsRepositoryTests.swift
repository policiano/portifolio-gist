import Domain
import DomainTestUtils
import Combine
import Utils
import UtilsTestUtils
import XCTest

@testable import Repository

final class MoyaGistsRepositoryTests: XCTestCase {
    private let moyaSpy = MoyaDataSourceSpy<GistsTargetType>()
    private lazy var bookmarksSpy: BookmarksRepositorySpy = {
        let repository = BookmarksRepositorySpy()
        repository.getBookmarkedGistsResultToBeReturned = .success([bookmarkedGist])
        return repository
    }()

    private lazy var sut = MoyaGistsRepository(
        dataSource: moyaSpy,
        bookmarksRepository: bookmarksSpy
    )

    private let bookmarkedGist = GistDigest.fixture()

    private typealias ResponseResult = Result<[GistDigestResponse]>
    private typealias DomainResult = Result<[GistDigest]>

    func test_onRequest_withAnyResult_shouldUseDependenciesProperly() {
        let expectedPage = Int.anyValue

        let failure = ResponseResult.failure(ErrorDummy())
        let success = ResponseResult.success([GistDigestResponse.fixture()])
        moyaSpy.requestResultToBeReturned = Bool.random() ? success : failure

        sut.getPublicGists(page: expectedPage) { _ in}

        XCTAssertTrue(moyaSpy.requestCalled)
        let requestPassed = moyaSpy.targetPassed as? PublicGistsRequest
        XCTAssertNotNil(requestPassed)
        XCTAssertEqual(requestPassed?.page, expectedPage)
    }

    func test_onRequest_withError_shouldReturnTheError() {
        let expectedPage = Int.anyValue
        let expectedError = ErrorDummy()
        moyaSpy.requestResultToBeReturned = ResponseResult.failure(expectedError)

        var actualResult: DomainResult?
        sut.getPublicGists(page: expectedPage) {
            actualResult = $0
        }

        XCTAssertEqual(actualResult?.error?.asErrorDummy, expectedError)
    }


    func test_onRequest_withWellFormedResponse_shouldMapToDomainModel() {
        let response = GistDigestResponse.fixture(
            id: bookmarkedGist.id,
            createdAt: String.anyValue,
            description: .anyValue,
            owner: .fixture(
                login: String.anyValue,
                avatarUrl: .anyValue
            ),
            files: [
                .anyValue: .fixture(filename: String.anyValue, type: String.anyValue)
            ]
        )

        moyaSpy.requestResultToBeReturned = ResponseResult.success([response])

        var actualResult: DomainResult?
        let exp = expectation(description: "get")

        sut.getPublicGists(page: Int.anyValue) {
            actualResult = $0
            exp.fulfill()
        }

        waitForExpectations(timeout: 10, handler: nil)
        XCTAssertEqual(actualResult?.value?.first?.id, response.id)
        XCTAssertEqual(actualResult?.value?.first?.isBookmarked, true)
    }

    func test_onRequest_withMalformedResponse_shouldMapToDomainModel() {
        let response = GistDigestResponse.fixture(id: nil)
        moyaSpy.requestResultToBeReturned = ResponseResult.success([response])

        var actualResult: DomainResult?
        sut.getPublicGists(page: Int.anyValue) {
            actualResult = $0
        }

        XCTAssertEqual(actualResult?.value?.count, 0)
    }
}

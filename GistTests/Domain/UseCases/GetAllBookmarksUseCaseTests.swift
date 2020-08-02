import XCTest

@testable import Gist

final class GetAllBookmarksUseCaseTests: XCTestCase {
    private let repositorySpy = BookmarksRepositorySpy()
    private lazy var sut = GetAllBookmarks(repository: repositorySpy)

    func test_onExecute_withFailureResult_shouldBypassTheResult() {
        let expectedError = ErrorDummy()
        repositorySpy.getBookmarkedGistsResultToBeReturned = .failure(expectedError)

        var actualError: Error?
        sut.execute {
            actualError = $0.error
        }

        XCTAssertTrue(repositorySpy.getBookmarkedGistsCalled)
        XCTAssertEqual(actualError?.asErrorDummy, expectedError)
    }

    func test_onExecute_withSuccessResult_shouldBypassTheResult() {
        let expectedGist = GistDigest.fixture()
        repositorySpy.getBookmarkedGistsResultToBeReturned = .success([expectedGist])

        var actualValue: [GistDigest]?
        sut.execute {
            actualValue = $0.value
        }

        XCTAssertTrue(repositorySpy.getBookmarkedGistsCalled)
        XCTAssertEqual(actualValue?.first, expectedGist)
    }
}

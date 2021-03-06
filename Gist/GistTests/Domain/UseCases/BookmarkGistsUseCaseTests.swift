import XCTest

@testable import Gist

final class BookmarkGistsUseCaseTests: XCTestCase {
    private let repositorySpy = BookmarksRepositorySpy()
    private lazy var sut = BookmarkGist(repository: repositorySpy)

    func test_onExecute_repositoryRetuningAFailure_shouldNotToggleBookmarkFlag() {
        repositorySpy.bookmarkResultToBeReturned = .failure(ErrorDummy())

        let expectedGist = GistDigest.fixture()
        expectedGist.isBookmarked = false

        var actualResult: Swift.Result<GistDigest, Never>?
        sut.execute(gist: expectedGist) {
            actualResult = $0
        }

        XCTAssertTrue(repositorySpy.bookmarkCalled)
        XCTAssertEqual(actualResult?.value, expectedGist)
        XCTAssertEqual(actualResult?.value?.isBookmarked, false)
    }

    func test_onExecute_repositoryRetuningASuccess_shouldToggleBookmarkFlag() {
        let expectedGist = GistDigest.fixture()
        expectedGist.isBookmarked = false

        repositorySpy.bookmarkResultToBeReturned = .success(expectedGist)

        var actualResult: Swift.Result<GistDigest, Never>?
        sut.execute(gist: expectedGist) {
            actualResult = $0
        }

        XCTAssertTrue(repositorySpy.bookmarkCalled)
        XCTAssertEqual(actualResult?.value, expectedGist)
        XCTAssertEqual(actualResult?.value?.isBookmarked, true)
    }
}


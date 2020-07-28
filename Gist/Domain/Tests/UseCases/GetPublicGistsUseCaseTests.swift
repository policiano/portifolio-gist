import XCTest

@testable import Gist

final class GetPublicGistsUseCaseTests: XCTestCase {
    private let repositorySpy = GistsRepositorySpy()
    private lazy var sut = GetPublicGists(repository: repositorySpy)

    func test_onExecute_repositoryRetuningAFailure_shouldReturnTheFailure() {
        let expectedError = ErrorDummy()
        repositorySpy.getPublicGistsResultToBeReturned = .failure(expectedError)

        var actualResult: Result<[GistDigest]>?
        sut.execute {
            actualResult = $0
        }

        XCTAssertEqual(actualResult?.error?.asErrorDummy, expectedError)
    }

    func test_onExecute_repositoryRetuningASuccess_shouldReturnTheList() {
        let gist = GistDigest.fixture()
        let expectedValues = [gist]
        repositorySpy.getPublicGistsResultToBeReturned = .success(expectedValues)

        var actualValues: [GistDigest]?
        sut.execute {
            actualValues = $0.value
        }

        XCTAssertEqual(actualValues?.count, expectedValues.count)
        XCTAssertEqual(actualValues?.first?.description, gist.description)
        XCTAssertEqual(actualValues?.first?.owner.name, gist.owner.name)
        XCTAssertEqual(actualValues?.first?.owner.avatarUrl, gist.owner.avatarUrl)
        XCTAssertEqual(actualValues?.first?.files.count, gist.files.count)
        XCTAssertEqual(actualValues?.first?.files.first?.name, gist.files.first?.name)
        XCTAssertEqual(actualValues?.first?.files.first?.type, gist.files.first?.type)
    }
}


@testable
import Gist
import XCTest

final class MoyaGistsRepositoryTests: XCTestCase {
    private let spy = MoyaDataSourceSpy<GistsTargetType>()
    private lazy var sut = MoyaGistsRepository(dataSource: spy)

    private typealias ResponseResult = Result<[GistDigestResponse]>
    private typealias DomainResult = Result<[GistDigest]>

    func test_onRequest_withAnyResult_shouldUseDependenciesProperly() {
        let expectedPage = Int.anyValue

        let failure = ResponseResult.failure(ErrorDummy())
        let success = ResponseResult.success([GistDigestResponse.fixture()])
        spy.requestResultToBeReturned = Bool.random() ? success : failure

        sut.getPublicGists(page: expectedPage) { _ in}

        XCTAssertTrue(spy.requestCalled)
        let requestPassed = spy.targetPassed as? PublicGistsRequest
        XCTAssertNotNil(requestPassed)
        XCTAssertEqual(requestPassed?.page, expectedPage)
    }

    func test_onRequest_withError_shouldReturnTheError() {
        let expectedPage = Int.anyValue
        let expectedError = ErrorDummy()
        spy.requestResultToBeReturned = ResponseResult.failure(expectedError)

        var actualResult: DomainResult?
        sut.getPublicGists(page: expectedPage) {
            actualResult = $0
        }

        XCTAssertEqual(actualResult?.error?.asErrorDummy, expectedError)
    }


    func test_onRequest_withWellFormedResponse_shouldMapToDomainModel() {
        let response = GistDigestResponse.fixture(
            id: String.anyValue,
            description: .anyValue,
            owner: .fixture(
                login: String.anyValue,
                avatarUrl: .anyValue
            ),
            files: [
                .anyValue: .fixture(filename: String.anyValue, type: String.anyValue)
            ]
        )
        spy.requestResultToBeReturned = ResponseResult.success([response])

        var actualResult: DomainResult?
        sut.getPublicGists(page: Int.anyValue) {
            actualResult = $0
        }

        XCTAssertEqual(actualResult?.value?.first?.id, response.id)
    }

    func test_onRequest_withMalformedResponse_shouldMapToDomainModel() {
        let response = GistDigestResponse.fixture(id: nil)
        spy.requestResultToBeReturned = ResponseResult.success([response])

        var actualResult: DomainResult?
        sut.getPublicGists(page: Int.anyValue) {
            actualResult = $0
        }

        XCTAssertEqual(actualResult?.value?.count, 0)
    }
}



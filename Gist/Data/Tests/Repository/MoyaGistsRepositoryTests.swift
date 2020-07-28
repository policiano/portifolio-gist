@testable
import Gist
import XCTest

final class MoyaGistsRepositoryTests: XCTestCase {
    private let spy = MoyaDataSourceSpy<GistsTargetType>()
    private lazy var sut = MoyaGistsRepository(dataSource: spy)

    private typealias ResponseResult = Result<[GistDigestResponse]>
    private typealias DomainResult = Result<[GistDigest]>

    func test_request_withError_shouldReturnTheError() {
        let expectedPage = Int.anyValue
        let expectedError = ErrorDummy()
        spy.requestResultToBeReturned = ResponseResult.failure(expectedError)

        var actualResult: DomainResult?
        sut.getPublicGists(page: expectedPage) {
            actualResult = $0
        }

        XCTAssertTrue(spy.requestCalled)
        XCTAssertEqual(actualResult?.error?.asErrorDummy, expectedError)
        let requestPassed = spy.targetPassed as? PublicGistsRequest
        XCTAssertNotNil(requestPassed)
        XCTAssertEqual(requestPassed?.page, expectedPage)
    }



}



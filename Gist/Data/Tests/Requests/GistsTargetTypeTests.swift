@testable
import Gist
import Moya
import XCTest

final class GistsTargetTypeTests: XCTestCase {
    private let sut = GistsTargetType()

    func test_sholdSetDefaultValuesProperly() {
        let expectedUrl = URLs.baseUrl + "/gists"
        XCTAssertEqual(sut.baseURL.absoluteString, expectedUrl)
        XCTAssertEqual(sut.headers, ["Accept": "application/vnd.github.v3+json"])
        XCTAssertTrue(sut.path.isEmpty)
        XCTAssertEqual(sut.method, .get)

        guard case .requestPlain = sut.task else {
            return XCTFail("The expected task is `\(Task.requestPlain)` got `\(sut.task)`")
        }

        guard case .successAndRedirectCodes = sut.validationType else {
            return XCTFail("The expected task is `\(ValidationType.successAndRedirectCodes)` got `\(sut.validationType)`")
        }
    }
}

@testable
import Gist
import Moya
import XCTest

final class PublicGistsRequestTests: XCTestCase {
    private let expectedPage = Int.anyValue
    private lazy var sut = PublicGistsRequest(page: expectedPage)

    func test_sholdSetDefaultValuesProperly() {
        let superClass = GistsTargetType()
        XCTAssertEqual(sut.baseURL, superClass.baseURL)

        XCTAssertEqual(sut.headers, superClass.headers)
        XCTAssertEqual(sut.path, "public")
        XCTAssertEqual(sut.method, superClass.method)

        let expectedParams = ["page": expectedPage]

        guard case .requestParameters(let param, _) = sut.task,
            param as? [String: Int] == expectedParams else {
            return XCTFail("The expected task is `\(Task.requestParameters(parameters: ["page": expectedPage], encoding: URLEncoding.queryString))`, got `\(sut.task)`")
        }

        guard case .successAndRedirectCodes = sut.validationType else {
            return XCTFail("The expected task is `\(ValidationType.successAndRedirectCodes)`, got `\(sut.validationType)`")
        }
    }
}

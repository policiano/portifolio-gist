@testable
import Gist
import XCTest

final class DiscoverTableViewControllerTests: XCTestCase {
    private let presenterSpy = DiscoverPresentationLogicSpy()
    private lazy var sut = DiscoverTableViewController(presenter: presenterSpy)

    func test_onViewDidLoad_shouldCallGetDiscoveries() {
        sut.viewDidLoad()

        XCTAssertEqual(sut.title, "Discover")
        XCTAssertTrue(presenterSpy.getDiscoveriesCalled)
    }
}

final class DiscoverPresentationLogicSpy: DiscoverPresentationLogic {
    private(set) var getDiscoveriesCalled = false
    func getDiscoveries(request: Discover.GetDiscoveries.Request) {
        getDiscoveriesCalled = true
    }
}

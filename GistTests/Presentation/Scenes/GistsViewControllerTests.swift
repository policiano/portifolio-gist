@testable
import Gist
import XCTest

final class GistsViewControllerTests: XCTestCase {
    private let presenterSpy = GistsPresentationLogicSpy()
    private let routerSpy = GistsPresenterTestsSpy()
    private lazy var sut = GistsViewController(
        presenter: presenterSpy,
        router: routerSpy
    )

    private let splitView = UISplitViewController()

    func test_onViewDidLoad_titleShouldBeSet() {
        sut.viewDidLoad()

        XCTAssertEqual(sut.title, "Discover")
    }

    func test_onLoadMore_getGistsShouldBeCalled() {
        sut.loadMore(1, .anyValue, onSuccess: nil, onError: nil)
        let exp = expectation(description: "getGistsCalled")
        exp.isInverted = true

        waitForExpectations(timeout: 2, handler: nil)
        XCTAssertTrue(presenterSpy.getGistsCalled)
    }

    // MARK: Routing Tests

    func test_didSelectRow_shouldRouteToDetails() {
        sut.displayGists(viewModel: .content(list: [.fixture()], hasMoreDataAvailable: false))
        sut.tableView.reloadData()

        sut.tableView(sut.tableView, didSelectRowAt: .init(row: 0, section: 0))

        XCTAssertTrue(routerSpy.routeToDigestCalled)
        XCTAssertEqual(routerSpy.routeToDigestIndexPassed, 0)
    }
}

final class GistsPresenterTestsSpy: GistsRoutingLogic {
    private(set) var routeToDigestCalled = false
    private(set) var routeToDigestIndexPassed: Int?
    func routeToDigest(forIndex index: Int) {
        routeToDigestCalled = true
        routeToDigestIndexPassed = index
    }

    func routeToBookmarks() {

    }
}


final class GistPresentationLogicDummy: GistPresentationLogic {
    func getDetails(request: GistDetails.GetDetails.Request) { }

    func bookmark(request: GistDetails.Bookmark.Request) { }
}

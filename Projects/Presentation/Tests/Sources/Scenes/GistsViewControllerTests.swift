import XCTest

@testable import Presentation

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
        let expectedViewModel = GistDigestCell.ViewModel.fixture(id: .anyValue)
        sut.displayGists(viewModel: .content(list: [expectedViewModel], hasMoreDataAvailable: false))
        sut.tableView.reloadData()

        sut.tableView(sut.tableView, didSelectRowAt: .init(row: 0, section: 0))

        XCTAssertTrue(routerSpy.routeToDigestCalled)
        XCTAssertEqual(routerSpy.routeToDigestViewModelPassed?.id, expectedViewModel.id)
    }
}

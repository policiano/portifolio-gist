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

    func test_onDisplayDiscoveries_withContent_shouldReloadTheTableView() {
        let viewModels = (0...5).map { _ in GistDigestView.ViewModel.fixture() }

        sut.displayDiscoveries(viewModel: .content(viewModels))

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), viewModels.count)
    }
}

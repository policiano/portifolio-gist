@testable
import Gist
import XCTest

final class GistsTableViewControllerTests: XCTestCase {
    private let presenterSpy = GistsPresentationLogicSpy()
    private lazy var sut = GistsViewController(presenter: presenterSpy)

    func test_onViewDidLoad_shouldCallGetGists() {
        sut.viewDidLoad()

        XCTAssertEqual(sut.title, "Gists")
        XCTAssertTrue(presenterSpy.getGistsCalled)
    }

    func test_onDisplayGists_withContent_shouldReloadTheTableView() {
        let viewModels = (0...5).map { _ in GistDigestCell.ViewModel.fixture() }

        sut.displayGists(viewModel: .content(viewModels))

        XCTAssertEqual(sut.tableView.numberOfRows(inSection: 0), viewModels.count)
    }
}

import Domain
import DomainTestUtils
import Utils
import XCTest

@testable import Presentation

final class GistsPresenterTests: XCTestCase {
    private let displaySpy = GistsDisplayLogicSpy()
    private let getGistsSpy = GetPublicGistsUseCaseSpy()
    private let bookmarkSpy = BookmarkGistUseCaseSpy()

    private lazy var sut: GistsPresenter = {
        let presenter = GistsPresenter(getPublicGists: getGistsSpy, bookmarkGist: bookmarkSpy)
        presenter.display = displaySpy
        return presenter
    }()

    private var actualViewModels: [GistDigestCell.ViewModel] {
        guard let content = displaySpy.displayGistsViewModelPassed,
            case .content(let viewModels, _) = content else {
                XCTFail("Expecting a content view model, got nil")
                return []
        }
        return viewModels
    }

    var gistListToBeReturned: [GistDigest] = [] {
        didSet {
            getGistsSpy.executeResultToBeReturned = .success(gistListToBeReturned)
            sut.getGists(request: .init())
        }
    }

    // MARK: Get Gists Use Case

    func test_getGists_shouldMapTheModelsProperly() {
        let gists = [GistDigest.fixture()]

        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getGists(request: .init())

        XCTAssertTrue(displaySpy.displayGistsCalled)
        XCTAssertEqual(actualViewModels.count, gists.count)
        XCTAssertEqual(actualViewModels[0].avatarUrl, gists[0].owner.avatarUrl)
        XCTAssertEqual(actualViewModels[0].ownerName, gists[0].owner.name)
        XCTAssertEqual(actualViewModels[0].secondaryText, gists[0].description)
    }

    func test_getGists_shouldReturnOnlyFourFileTypes() {
        var gists = [GistDigest.fixture(files: (0...7).map { _ in .fixture() })]
        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getGists(request: .init())

        XCTAssertEqual(actualViewModels[0].fileTags.count, 5)
        XCTAssertEqual(actualViewModels[0].fileTags.last, "...")

        gists = [GistDigest.fixture(files: (0...3).map { _ in .fixture() })]
        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getGists(request: .init())

        XCTAssertEqual(actualViewModels[0].fileTags.count, gists[0].files.count + 1)
    }

    // MARK: Get Gists Use Case

    func test_bookmark_tryingBookmarkANotFoundGist_shouldDoNothing() {
        let expectedGist = GistDigestCell.ViewModel.fixture(isBookmarked: false)

        sut.bookmark(request: .init(gist: expectedGist))

        XCTAssertFalse(bookmarkSpy.executeCalled)
        XCTAssertFalse(displaySpy.displayBookmarkCalled)
    }

    func test_bookmark_aListedGist_shouldReturnABookmarkedGistViewModel_andItsIndexPath() {
        let bookMarkedGist = GistDigest.fixture()
        bookMarkedGist.isBookmarked = false
        
        let expectedGist = GistDigestCell.ViewModel.fixture(
            id: bookMarkedGist.id,
            isBookmarked: bookMarkedGist.isBookmarked
        )
        // Given the bookmark gist is listed
        gistListToBeReturned = [bookMarkedGist]
        bookmarkSpy.executeResultToBeReturned = .success(bookMarkedGist)

        // When a gist is bookmarked
        sut.bookmark(request: .init(gist: expectedGist))

        // Then it should be updated and sent back to the display
        XCTAssertTrue(bookmarkSpy.executeCalled)
        XCTAssertTrue(displaySpy.displayBookmarkCalled)

        let viewModelPassed = displaySpy.displayBookmarkViewModelPassed

        XCTAssertEqual(viewModelPassed?.bookmarkedGist.id, expectedGist.id)
    }

    // MARK: Check Updates Use Case

    func test_checkSelectedGistUpdates_thereIsNoSelectedGist_shouldDoNothing() {
        sut.checkSelectedGistUpdates(request: .init(selectedGist: nil))

        XCTAssertFalse(displaySpy.updateSelectedGistCalled)
    }

    func test_checkSelectedGistUpdates_selectedGistIsNotListed_shouldDoNothing() {
        let selectedGist = GistDigestCell.ViewModel.fixture()
        sut.checkSelectedGistUpdates(request: .init(selectedGist: selectedGist))

        XCTAssertFalse(displaySpy.updateSelectedGistCalled)
    }

    func test_checkSelectedGistUpdates_selectedGistIsListed_shouldCallDisplay() {
        let selectedGist = GistDigestCell.ViewModel.fixture()
        gistListToBeReturned = [
            .fixture(),
            .fixture(id: selectedGist.id)
        ]

        sut.checkSelectedGistUpdates(request: .init(selectedGist: selectedGist))

        let viewModelPassed = displaySpy.updateSelectedGistViewModelPassed
        XCTAssertTrue(displaySpy.updateSelectedGistCalled)
        XCTAssertEqual(viewModelPassed?.index.row, 1)
        XCTAssertEqual(viewModelPassed?.index.section, 0)
        XCTAssertEqual(viewModelPassed?.selectedGist.id, selectedGist.id)
    }
}

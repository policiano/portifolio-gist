@testable
import Gist
import XCTest

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
        let expectedIndexPath = IndexPath(row: .anyValue, section: .anyValue)
        let expectedGist = GistDigestCell.ViewModel.fixture(isBookmarked: false)

        sut.bookmark(request: .init(index: expectedIndexPath, gist: expectedGist))

        XCTAssertFalse(bookmarkSpy.executeCalled)
        XCTAssertFalse(displaySpy.displayBookmarkCalled)
    }

    func test_bookmark_aListedGist_shouldReturnABookmarkedGistViewModel_andItsIndexPath() {
        let expectedIndexPath = IndexPath(row: .anyValue, section: .anyValue)
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
        sut.bookmark(request: .init(index: expectedIndexPath, gist: expectedGist))

        // Then it should be updated and sent back to the display
        XCTAssertTrue(bookmarkSpy.executeCalled)
        XCTAssertTrue(displaySpy.displayBookmarkCalled)

        let viewModelPassed = displaySpy.displayBookmarkViewModelPassed

        XCTAssertEqual(viewModelPassed?.bookmarkedGist.id, expectedGist.id)
        XCTAssertEqual(viewModelPassed?.index, expectedIndexPath)
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

final class GistsDisplayLogicSpy: GistsDisplayLogic {
    private(set) var updateSelectedGistCalled = false
    private(set) var updateSelectedGistViewModelPassed: Gists.CheckUpdates.ViewModel?
    func updateSelectedGist(viewModel: Gists.CheckUpdates.ViewModel) {
        updateSelectedGistCalled = true
        updateSelectedGistViewModelPassed = viewModel
    }

    private(set) var displayBookmarkCalled = false
    private(set) var displayBookmarkViewModelPassed: Gists.Bookmark.ViewModel?
    func displayBookmark(viewModel: Gists.Bookmark.ViewModel) {
        displayBookmarkCalled = true
        displayBookmarkViewModelPassed = viewModel
    }


    private(set) var displayGistsCalled = false
    private(set) var displayGistsViewModelPassed: Gists.GetGists.ViewModel?
    func displayGists(viewModel: Gists.GetGists.ViewModel) {
        displayGistsCalled = true
        displayGistsViewModelPassed = viewModel
    }
}

public final class GetPublicGistsUseCaseSpy: GetPublicGistsUseCase {
    public private(set) var executeCalled = false
    public var executeResultToBeReturned: Result<[GistDigest]>?

    public func execute(completion: @escaping (Result<[GistDigest]>) -> Void) {
        executeCalled = true
        if let result = executeResultToBeReturned {
            completion(result)
        }
    }
}

public final class BookmarkGistUseCaseSpy: BookmarkGistUseCase {

    private(set) var executeCalled = false
    private(set) var executeGistPassed: GistDigest?
    var executeResultToBeReturned: Swift.Result<GistDigest, Never>?

    public func execute(gist: GistDigest, _ completion: @escaping (Swift.Result<GistDigest, Never>) -> Void) {
        executeCalled = true
        executeGistPassed = gist
        if let result = executeResultToBeReturned {
            completion(result)
        }
    }
}


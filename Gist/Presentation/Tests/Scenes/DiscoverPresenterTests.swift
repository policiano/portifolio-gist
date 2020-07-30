@testable
import Gist
import XCTest

final class DiscoverPresenterTests: XCTestCase {
    private let displaySpy = DiscoverDisplayLogicSpy()
    private let getGistsSpy = GetPublicGistsUseCaseSpy()
    private lazy var sut: DiscoverPresenter = {
        let presenter = DiscoverPresenter(getPublicGists: getGistsSpy)
        presenter.display = displaySpy
        return presenter
    }()

    private var actualViewModels: [GistDigestView.ViewModel] {
        guard let content = displaySpy.displayDiscoveriesViewModelPassed,
            case .content(let viewModels) = content else {
                XCTFail("Expecting a content view model, got nil")
                return []
        }
        return viewModels
    }

    func test_getDiscoveries_shouldMapTheModelsProperly() {
        let gists = [GistDigest.fixture()]

        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getDiscoveries(request: .init())

        XCTAssertTrue(displaySpy.displayDiscoveriesCalled)
        XCTAssertEqual(actualViewModels.count, gists.count)
        XCTAssertEqual(actualViewModels[0].avatarUrl, gists[0].owner.avatarUrl)
        XCTAssertEqual(actualViewModels[0].ownerName, gists[0].owner.name)
        XCTAssertEqual(actualViewModels[0].secondaryText, gists[0].description)
    }

    func test_getDiscoveries_shouldReturnOnlyFourFileTypes() {
        var gists = [GistDigest.fixture(files: (0...7).map { _ in .fixture() })]
        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getDiscoveries(request: .init())

        XCTAssertEqual(actualViewModels[0].fileTypes.count, 5)
        XCTAssertEqual(actualViewModels[0].fileTypes.last, "...")

        gists = [GistDigest.fixture(files: (0...3).map { _ in .fixture() })]
        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getDiscoveries(request: .init())

        XCTAssertEqual(actualViewModels[0].fileTypes.count, gists[0].files.count)
    }
}

final class DiscoverDisplayLogicSpy: DiscoverDisplayLogic {

    private(set) var displayDiscoveriesCalled = false
    private(set) var displayDiscoveriesViewModelPassed: Discover.GetDiscoveries.ViewModel?
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel) {
        displayDiscoveriesCalled = true
        displayDiscoveriesViewModelPassed = viewModel
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

@testable
import Gist
import XCTest

final class GistsPresenterTests: XCTestCase {
    private let displaySpy = GistsDisplayLogicSpy()
    private let getGistsSpy = GetPublicGistsUseCaseSpy()
    private lazy var sut: GistsPresenter = {
        let presenter = GistsPresenter(getPublicGists: getGistsSpy)
        presenter.display = displaySpy
        return presenter
    }()

    private var actualViewModels: [GistDigestCell.ViewModel] {
        guard let content = displaySpy.displayGistsViewModelPassed,
            case .content(let viewModels) = content else {
                XCTFail("Expecting a content view model, got nil")
                return []
        }
        return viewModels
    }

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

        XCTAssertEqual(actualViewModels[0].fileTypes.count, 5)
        XCTAssertEqual(actualViewModels[0].fileTypes.last, "...")

        gists = [GistDigest.fixture(files: (0...3).map { _ in .fixture() })]
        getGistsSpy.executeResultToBeReturned = .success(gists)

        sut.getGists(request: .init())

        XCTAssertEqual(actualViewModels[0].fileTypes.count, gists[0].files.count)
    }
}

final class GistsDisplayLogicSpy: GistsDisplayLogic {

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

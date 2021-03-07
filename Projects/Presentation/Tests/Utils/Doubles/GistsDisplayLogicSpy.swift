@testable import Presentation

public final class GistsDisplayLogicSpy: GistsDisplayLogic {
    public init() { }
    
    public private(set) var updateSelectedGistCalled = false
    public private(set) var updateSelectedGistViewModelPassed: Gists.CheckUpdates.ViewModel?
    public func updateSelectedGist(viewModel: Gists.CheckUpdates.ViewModel) {
        updateSelectedGistCalled = true
        updateSelectedGistViewModelPassed = viewModel
    }

    public private(set) var displayBookmarkCalled = false
    public private(set) var displayBookmarkViewModelPassed: Gists.Bookmark.ViewModel?
    public func displayBookmark(viewModel: Gists.Bookmark.ViewModel) {
        displayBookmarkCalled = true
        displayBookmarkViewModelPassed = viewModel
    }


    public private(set) var displayGistsCalled = false
    public private(set) var displayGistsViewModelPassed: Gists.GetGists.ViewModel?
    public func displayGists(viewModel: Gists.GetGists.ViewModel) {
        displayGistsCalled = true
        displayGistsViewModelPassed = viewModel
    }
}

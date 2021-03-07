@testable import Presentation

public final class GistsPresentationLogicSpy: GistsPresentationLogic {
    public init() { }
    
    public private(set) var getGistsCalled = false
    public func getGists(request: Gists.GetGists.Request) {
        getGistsCalled = true
    }

    public private(set) var checkSelectedGistUpdatesCalled = false
    public private(set) var checkSelectedGistUpdatesRequestPassed: Gists.CheckUpdates.Request?
    public func checkSelectedGistUpdates(request: Gists.CheckUpdates.Request) {
        checkSelectedGistUpdatesCalled = true
        checkSelectedGistUpdatesRequestPassed = request
    }

    public private(set) var bookmarkCalled = false
    public private(set) var bookmarkRequestPassed: Gists.Bookmark.Request?
    public func bookmark(request: Gists.Bookmark.Request) {
        bookmarkCalled = true
        bookmarkRequestPassed = request
    }
}

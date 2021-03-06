@testable
import Gist

final class GistsPresentationLogicSpy: GistsPresentationLogic {

    private(set) var getGistsCalled = false
    func getGists(request: Gists.GetGists.Request) {
        getGistsCalled = true
    }

    private(set) var checkSelectedGistUpdatesCalled = false
    private(set) var checkSelectedGistUpdatesRequestPassed: Gists.CheckUpdates.Request?
    func checkSelectedGistUpdates(request: Gists.CheckUpdates.Request) {
        checkSelectedGistUpdatesCalled = true
        checkSelectedGistUpdatesRequestPassed = request
    }

    private(set) var bookmarkCalled = false
    private(set) var bookmarkRequestPassed: Gists.Bookmark.Request?
    func bookmark(request: Gists.Bookmark.Request) {
        bookmarkCalled = true
        bookmarkRequestPassed = request
    }
}

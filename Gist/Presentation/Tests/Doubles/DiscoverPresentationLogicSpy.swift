@testable
import Gist

final class GistsPresentationLogicSpy: GistsPresentationLogic {
    private(set) var getGistsCalled = false
    func getGists(request: Gists.GetGists.Request) {
        getGistsCalled = true
    }
}

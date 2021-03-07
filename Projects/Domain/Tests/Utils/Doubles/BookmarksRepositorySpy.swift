import Domain
import Utils

final class BookmarksRepositorySpy: BookmarksRepository {

    private(set) var bookmarkCalled = false
    private(set) var bookmarkGistPassed: GistDigest?
    var bookmarkResultToBeReturned: Result<GistDigest>?
    func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void) {
        bookmarkGistPassed = gist
        bookmarkCalled = true
        if let result = bookmarkResultToBeReturned {
            completion(result)
        }
    }

    private(set) var getBookmarkedGistsCalled = true
    var getBookmarkedGistsResultToBeReturned: Result<[GistDigest]>?
    func getBookmarkedGists(completion: @escaping (Result<[GistDigest]>) -> Void) {
        getBookmarkedGistsCalled = true
        if let result = getBookmarkedGistsResultToBeReturned {
            completion(result)
        }
    }
}

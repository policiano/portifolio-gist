import Domain
import Repository
import Utils

public final class BookmarksRepositorySpy: BookmarksRepository {
    public init() { }

    public private(set) var bookmarkCalled = false
    public private(set) var bookmarkGistPassed: GistDigest?
    public var bookmarkResultToBeReturned: Result<GistDigest>?
    public func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void) {
        bookmarkGistPassed = gist
        bookmarkCalled = true
        if let result = bookmarkResultToBeReturned {
            completion(result)
        }
    }

    public private(set) var getBookmarkedGistsCalled = true
    public var getBookmarkedGistsResultToBeReturned: Result<[GistDigest]>?
    public func getBookmarkedGists(completion: @escaping (Result<[GistDigest]>) -> Void) {
        getBookmarkedGistsCalled = true
        if let result = getBookmarkedGistsResultToBeReturned {
            completion(result)
        }
    }
}

import Foundation

public final class FirebaseBookmarksRepository {
    static let shared = FirebaseBookmarksRepository()
    var bookmarks: [GistDigest] = []
}

extension FirebaseBookmarksRepository: BookmarksRepository {
    public func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void) {
        bookmarks.append(gist)
        completion(.success(gist))
    }
}

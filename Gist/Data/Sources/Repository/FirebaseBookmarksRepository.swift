import Foundation

public final class FirebaseBookmarksRepository {
    static let shared = FirebaseBookmarksRepository()
    var bookmarks: Set<GistDigest> = []

    private func addToBookmarks(_ gist: GistDigest) {
        bookmarks.insert(gist)
    }

    private func removeFromBookmarks(_ gist: GistDigest) {
        bookmarks.remove(gist)
    }
}

extension FirebaseBookmarksRepository: BookmarksRepository {
    public func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void) {
        if gist.isBookmarked == true {
            addToBookmarks(gist)
        } else {
            removeFromBookmarks(gist)
        }

        completion(.success(gist))
    }

    public func getBookmarkedGists(completion: @escaping (Result<[GistDigest]>) -> Void) {
        completion(.success(Array(bookmarks)))
    }
}

extension GistDigest: Equatable {

    public static func == (lhs: GistDigest, rhs: GistDigest) -> Bool {
        lhs.id == rhs.id
    }
}

extension GistDigest: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

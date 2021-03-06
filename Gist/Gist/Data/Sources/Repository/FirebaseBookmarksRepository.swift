import Foundation

public final class FirebaseBookmarksRepository {
    private let database: DatabaseDataSource

    public init(database: DatabaseDataSource = FirebaseDataSource()) {
        self.database = database
    }

    private func addToBookmarks(_ gist: GistDigest) throws {
        try database.set(gist, withId: gist.id, forKey: "bookmarks")
    }

    private func removeFromBookmarks(_ gist: GistDigest) {
        database.deleteData(withId: gist.id, forKey: "bookmarks")
    }
}

extension FirebaseBookmarksRepository: BookmarksRepository {
    public func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void) {
        do {
            if gist.isBookmarked == true {
                try addToBookmarks(gist)
            } else {
                removeFromBookmarks(gist)
            }

            completion(.success(gist))
        } catch {
            completion(.failure(error))
        }
    }

    public func getBookmarkedGists(completion: @escaping (Result<[GistDigest]>) -> Void) {
        database.getAll(forKey: "bookmarks", completion: completion)
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

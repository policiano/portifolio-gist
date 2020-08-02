import Foundation

public protocol BookmarksRepository {
    func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void)
    func getBookmarkedGists(completion: @escaping (Result<[GistDigest]>) -> Void)
}

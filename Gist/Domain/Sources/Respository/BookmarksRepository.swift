import Foundation

public protocol BookmarksRepository {
    func bookmark(gist: GistDigest, completion: @escaping (Result<GistDigest>) -> Void)
}

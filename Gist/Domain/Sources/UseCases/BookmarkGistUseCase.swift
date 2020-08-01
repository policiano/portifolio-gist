import Foundation

public protocol BookmarkGistUseCase {
    func execute(gist: GistDigest, completion: @escaping (Swift.Result<GistDigest, Never>) -> Void)
}

public final class BookmarkGist {
    private let repository: BookmarksRepository

    public init(repository: BookmarksRepository) {
        self.repository = repository
    }
}

extension BookmarkGist: BookmarkGistUseCase {
    public func execute(gist: GistDigest, completion: @escaping (Swift.Result<GistDigest, Never>) -> Void) {
        gist.isBookmarked = true

        repository.bookmark(gist: gist) {
            switch $0 {
            case .success(let bookmarkedGist):
                completion(.success(bookmarkedGist))
            case .failure:
                gist.isBookmarked = false
                completion(.success(gist))
            }
        }
    }
}

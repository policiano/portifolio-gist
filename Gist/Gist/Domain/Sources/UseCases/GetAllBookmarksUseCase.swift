import Foundation

public protocol GetAllBookmarksUseCase {
    func execute(completion: @escaping (Result<[GistDigest]>) -> Void)
}

public final class GetAllBookmarks {
    private let repository: BookmarksRepository

    public init(repository: BookmarksRepository) {
        self.repository = repository
    }
}

extension GetAllBookmarks: GetAllBookmarksUseCase {
    public func execute(completion: @escaping (Result<[GistDigest]>) -> Void) {
        repository.getBookmarkedGists(completion: completion)
    }
}

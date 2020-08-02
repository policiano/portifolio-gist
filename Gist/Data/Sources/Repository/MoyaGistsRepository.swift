import Foundation
import Combine

public final class MoyaGistsRepository {
    private let dataSource: MoyaDataSource<GistsTargetType>
    private let bookmarksRepository: BookmarksRepository
    private var isFetchInProgress = false
    private var cancellable: Cancellable?

    public init(
        dataSource: MoyaDataSource<GistsTargetType> = .init(),
        bookmarksRepository: BookmarksRepository
    ) {
        self.dataSource = dataSource
        self.bookmarksRepository = bookmarksRepository
    }

    private func bookmarkIfNeeded(newGists: [GistDigest], bookmarks: [GistDigest]) -> [GistDigest] {
        let bookmarkedIds = bookmarks.map { $0.id }
        return newGists.map {
            $0.isBookmarked = bookmarkedIds.contains($0.id)
            return $0
        }
    }
}

extension MoyaGistsRepository: GistsRepository {

    public func getPublicGists(page: Int, completion: @escaping (Result<[GistDigest]>) -> Void) {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true

        let bookmarksFuture = Future<[GistDigest], Error>() { promise in
            self.bookmarksRepository.getBookmarkedGists {
                promise(.success($0.value ?? []))
            }
        }

        let gistPageFuture = Future<[GistDigest], Error>() { promise in
            let request = PublicGistsRequest(page: page)
            self.dataSource.request(request) { (result: Result<[GistDigestResponse]>) in
                self.isFetchInProgress = false

                switch result {
                case .success(let responseList):
                    let gists = responseList.compactMap(GistDigest.init)
                    promise(.success(gists))
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }

        cancellable = gistPageFuture.zip(bookmarksFuture)
            .map(bookmarkIfNeeded)
            .sink(receiveCompletion: { (request) in
                if case .failure(let error) = request {
                    completion(.failure(error))
                }
            }) {
                completion(.success($0))
            }
    }
}

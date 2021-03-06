import Foundation
import Combine

public final class MoyaGistsRepository: NSObject {
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

    private func requestGists(page: Int, _ completion: @escaping (Result<[GistDigest]>) -> Void) {
        let request = PublicGistsRequest(page: page)

        self.dataSource.request(request, completion: weakfy { (strongSelf, result: Result<[GistDigestResponse]>) in
            strongSelf.isFetchInProgress = false

            switch result {
            case .success(let responseList):
                let gists = responseList.compactMap(GistDigest.init)
                completion(.success(gists))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}

extension MoyaGistsRepository: GistsRepository {

    public func getPublicGists(page: Int, completion: @escaping (Result<[GistDigest]>) -> Void) {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true

        let bookmarksFuture = Future<[GistDigest], Error>(weakfy { strongSelf, promise in
            strongSelf.bookmarksRepository.getBookmarkedGists {
                promise(.success($0.value ?? []))
            }
        })

        let gistPageFuture = Future<[GistDigest], Error>(weakfy { strongSelf, promise in

            strongSelf.requestGists(page: page) {
                promise($0)
            }
        })

        cancellable = gistPageFuture.zip(bookmarksFuture)
            .map(bookmarkIfNeeded)
            .sink(receiveCompletion: weakfy { strongSelf, request in
                strongSelf.isFetchInProgress = false

                if case .failure(let error) = request {
                    completion(.failure(error))
                }
            }, receiveValue: weakfy { (strongSelf, gists) in
                strongSelf.isFetchInProgress = false

                completion(.success(gists))
            })
    }
}

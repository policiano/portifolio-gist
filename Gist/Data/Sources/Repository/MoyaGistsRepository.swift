import Foundation

public final class MoyaGistsRepository {
    private let dataSource: MoyaDataSource<GistsTargetType>
    private var isFetchInProgress = false

    public init(dataSource: MoyaDataSource<GistsTargetType> = .init()) {
        self.dataSource = dataSource
    }
}

extension MoyaGistsRepository: GistsRepository {

    public func getPublicGists(page: Int, completion: @escaping (Result<[GistDigest]>) -> Void) {
        guard !isFetchInProgress else {
            return
        }

        isFetchInProgress = true

        let request = PublicGistsRequest(page: page)

        dataSource.request(request) { [weak self] (result: Result<[GistDigestResponse]>) in
            guard let self = self else { return }
            
            self.isFetchInProgress = false

            switch result {
            case .success(let responseList):
                let gists = responseList.compactMap(GistDigest.init)
                completion(.success(gists))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

import Foundation

public final class MoyaGistsRepository {
    private let dataSource: MoyaDataSource<GistsTargetType>

    public init(dataSource: MoyaDataSource<GistsTargetType> = .init()) {
        self.dataSource = dataSource
    }
}

extension MoyaGistsRepository: GistsRepository {

    public func getPublicGists(page: Int, completion: @escaping (Result<[GistDigest]>) -> Void) {
        let request = PublicGistsRequest(page: page)

        dataSource.request(request) { (result: Result<[GistDigestResponse]>) in
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

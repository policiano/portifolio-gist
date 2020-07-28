import Foundation

public final class MoyaGistsRepository {
    private let dataSource: MoyaDataSource<PublicGistsRequest>

    public init(dataSource: MoyaDataSource<PublicGistsRequest> = .init()) {
        self.dataSource = dataSource
    }
}
extension MoyaGistsRepository: GistsRepository {

    public func getPublicGists(completion: @escaping (Result<[GistDigest]>) -> Void) {
        let request = PublicGistsRequest(currentPage: 0)
        dataSource.request(request) { [weak self] (result: Result<[GistDigestResponse]>) in
            print(result.value)
        }
    }
}

import Foundation

public protocol GetPublicGistsUseCase {
    func execute(completion: @escaping (Result<[GistDigest]>) -> Void)
}

public final class GetPublicGists {
    private let repository: GistsRepository

    public init(repository: GistsRepository) {
        self.repository = repository
    }
}

extension GetPublicGists: GetPublicGistsUseCase {
    public func execute(completion: @escaping (Result<[GistDigest]>) -> Void) {
        repository.getPublicGists(page: 0, completion: completion)
    }
}

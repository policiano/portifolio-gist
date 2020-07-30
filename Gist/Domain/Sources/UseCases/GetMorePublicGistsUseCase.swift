import Foundation

public protocol GetMorePublicGistsUseCase {
    func execute(completion: @escaping (Result<[GistDigest]>) -> Void)
}

public final class GetMorePublicGists {
    private let repository: GistsRepository
    private var currentPage = 0

    public init(repository: GistsRepository) {
        self.repository = repository
    }
}

extension GetMorePublicGists: GetMorePublicGistsUseCase {
    public func execute(completion: @escaping (Result<[GistDigest]>) -> Void) {

        repository.getPublicGists(page: currentPage) { [weak self] in
            guard let self = self else { return }

            if case .success = $0 {
                self.currentPage += 1
            }

            completion($0)
        }
    }
}

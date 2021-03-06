import Utils
import Combine

public protocol GetPublicGistsUseCase {
    func execute(completion: @escaping (Result<[GistDigest]>) -> Void)
}

public final class GetPublicGists {
    private let repository: GistsRepository
    private var currentPage = 1

    public init(
        repository: GistsRepository
    ) {
        self.repository = repository
    }
}

extension GetPublicGists: GetPublicGistsUseCase {
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

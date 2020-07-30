import Foundation

protocol DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request)
}

protocol DiscoverDataStore {
    var gists: [GistDigest] { get set }
}

final class DiscoverPresenter: DiscoverDataStore {
    private let getPublicGists: GetPublicGistsUseCase
    var gists: [GistDigest] = []

    weak var display: DiscoverDisplayLogic?

    init(getPublicGists: GetPublicGistsUseCase) {
        self.getPublicGists = getPublicGists
    }

    private func makeViewModel(with gists: [GistDigest]) -> Discover.GetDiscoveries.ViewModel {
        .content(gists.map(self.map(gist:)))
    }

    private func map(gist: GistDigest) -> GistDigestView.ViewModel {
        let fileTags = gist.fileTags(threshold: 4)

        return .init(
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: gist.formmatedDescription,
            fileTags: fileTags
        )
    }
}

extension DiscoverPresenter: DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request) {
        getPublicGists.execute { [weak self] in
            guard let self = self else { return }
            let viewModel: Discover.GetDiscoveries.ViewModel

            switch $0 {
            case .success(let gists):
                self.gists = gists

                if gists.isEmpty {
                    let error = ErrorHandler.userError()
                    viewModel = .failure(error)
                } else {
                    viewModel = self.makeViewModel(with: gists)
                }
            case .failure(let error):
                let userError = ErrorHandler.userError(from: error)
                viewModel = .failure(userError)
            }

            self.display?.displayDiscoveries(viewModel: viewModel)
        }
    }
}

extension GistDigest {
    var formmatedDescription: String? {
        description?.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .filter{ !$0.isEmpty }
            .joined(separator: "\n")
    }

    func fileTags(threshold: Int? = nil) -> [String] {
        var fileTypes = files.map { $0.type }

        guard let threshold = threshold else {
            return fileTypes
        }

        fileTypes = Array(fileTypes.suffix(threshold))

        if files.count > threshold {
            fileTypes.append("...")
        }

        return fileTypes
    }
}

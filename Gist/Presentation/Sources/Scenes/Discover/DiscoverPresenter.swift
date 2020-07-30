import Foundation

protocol DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request)
}

final class DiscoverPresenter {
    private let getPublicGists: GetPublicGistsUseCase
    weak var display: DiscoverDisplayLogic?

    init(getPublicGists: GetPublicGistsUseCase) {
        self.getPublicGists = getPublicGists
    }

    private func makeViewModel(with gists: [GistDigest]) -> Discover.GetDiscoveries.ViewModel {
        .content(gists.map(self.map(gist:)))
    }

    private func map(gist: GistDigest) -> GistDigestView.ViewModel {
        var fileTypes = gist.files.suffix(4).map { $0.type }
        if gist.files.count > 4 {
            fileTypes.append("...")
        }

        let description = gist.description?
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .filter{ !$0.isEmpty }
            .joined(separator: "\n")

        return .init(
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: description,
            fileTypes: fileTypes
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
                viewModel = self.makeViewModel(with: gists)
            case .failure(let error):
                viewModel = .failure
            }

            self.display?.displayDiscoveries(viewModel: viewModel)
        }
    }
}

import Foundation

protocol DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request)
    func selectGist(request: Discover.SelectGist.Request)
}

final class DiscoverPresenter {
    private let getPublicGists: GetPublicGistsUseCase
    private var gists: [GistDigest] = []

    weak var display: DiscoverDisplayLogic?

    init(getPublicGists: GetPublicGistsUseCase) {
        self.getPublicGists = getPublicGists
    }

    private func makeViewModel(with gists: [GistDigest]) -> Discover.GetDiscoveries.ViewModel {
        .content(gists.map(self.map(gist:)))
    }

    private func map(gist: GistDigest) -> GistDigestView.ViewModel {
        map(gist: gist, prepareForDetail: false)
    }

    private func map(gist: GistDigest, prepareForDetail: Bool) -> GistDigestView.ViewModel {
        var fileTypes = gist.files.suffix(4).map { $0.type }
        if gist.files.count > 4 {
            fileTypes.append("...")
        }

        let secondaryText: String?
        if prepareForDetail {
            secondaryText = "date"
        } else {
            secondaryText = buildDescription(from: gist.description)
        }

        return .init(
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: secondaryText,
            fileTypes: fileTypes
        )
    }

    private func buildDescription(from string: String?) -> String? {
        string?.trimmingCharacters(in: .whitespacesAndNewlines)
            .components(separatedBy: .newlines)
            .filter{ !$0.isEmpty }
            .joined(separator: "\n")
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

    func selectGist(request: Discover.SelectGist.Request) {
        let index = request.index

        guard let selectedGist = gists[safeIndex: index] else {
            return
        }

        let headerViewModel = map(gist: selectedGist, prepareForDetail: true)
        let files = selectedGist.files.map { $0.name }

        let viewModel = Discover.SelectGist.ViewModel(
            headerViewModel: headerViewModel,
            description: buildDescription(from: selectedGist.description),
            files: files
        )

        display?.displaySelectedGist(viewModel: viewModel)
    }
}

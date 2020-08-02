import Foundation

protocol DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request)
    func checkSelectedGistUpdates(request: Discover.CheckUpdates.Request)
    func bookmark(request: Discover.Bookmark.Request)
}

protocol DiscoverDataStore {
    var gists: [GistDigest] { get set }
}

class DiscoverPresenter: NSObject, DiscoverDataStore {
    private let getPublicGists: GetPublicGistsUseCase
    private let bookmarkGist: BookmarkGistUseCase
    var gists: [GistDigest] = []

    weak var display: DiscoverDisplayLogic?

    init(
        getPublicGists: GetPublicGistsUseCase,
        bookmarkGist: BookmarkGistUseCase
    ) {
        self.getPublicGists = getPublicGists
        self.bookmarkGist = bookmarkGist
    }

    fileprivate func mapGist(_ gist: GistDigest) -> GistDigestCell.ViewModel {
        let fileTags = gist.fileTags(threshold: 4)

        return .init(
            id: gist.id,
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: gist.formmatedDescription,
            fileTags: fileTags,
            isBookmarked: gist.isBookmarked
        )
    }

    private func calculateIndexPathsToReload(from newGists: [GistDigest]) -> [IndexPath] {
        let startIndex = gists.count - newGists.count
        let endIndex = startIndex + newGists.count
        return (startIndex..<endIndex).map { IndexPath(row: $0, section: 0) }
    }

    fileprivate func fetchAndDisplay() {
        getPublicGists.execute { [weak self] in
            guard let self = self else { return }

            switch $0 {
            case .success(let newGists):
                self.gists.append(contentsOf: newGists)
                self.gists = self.gists.uniques
                let content = self.gists.map(self.mapGist)

                self.display?.displayDiscoveries(viewModel:
                    .content(
                        list: content,
                        hasMoreDataAvailable: !newGists.isEmpty
                    )
                )
            case .failure(let error):
                let userError = ErrorHandler.userError(from: error)
                self.display?.displayDiscoveries(viewModel:
                    .failure(userError)
                )
            }
        }
    }
}

extension DiscoverPresenter: DiscoverPresentationLogic {
    func getDiscoveries(request: Discover.GetDiscoveries.Request) {
        fetchAndDisplay()
    }

    func bookmark(request: Discover.Bookmark.Request) {
        guard let bookmarkedGist = gists.first(where: { $0.id == request.gist.id }) else {
            return
        }

        let index = request.index

        bookmarkGist.execute(gist: bookmarkedGist, weakfy { (strongSelf, result) in
            guard let updatedGist = result.value else {
                return
            }

            let viewModel = Discover.Bookmark.ViewModel(
                index: index,
                bookmarkedGist: self.mapGist(updatedGist)
            )
            self.display?.displayBookmark(viewModel: viewModel)
        })
    }

    func checkSelectedGistUpdates(request: Discover.CheckUpdates.Request) {
        guard let selectedGist = request.selectedGist,
            let (index, gist) = gists.enumerated().first(where: { $1.id == selectedGist.id }) else { return }

        let indexPath = IndexPath(row: index, section: 0)
        let mappedGist = mapGist(gist)
        display?.updateSelectedGist(viewModel: .init(index: indexPath, selectedGist: mappedGist))
    }
}

class BookmarksPresenter: DiscoverPresenter {
    private let getAllBookmarks: GetAllBookmarksUseCase

    init(getAllBookmarks: GetAllBookmarksUseCase, getPublicGists: GetPublicGistsUseCase, bookmarkGist: BookmarkGistUseCase) {
        self.getAllBookmarks = getAllBookmarks
        super.init(getPublicGists: getPublicGists, bookmarkGist: bookmarkGist)
    }

    override func fetchAndDisplay() {
        guard gists.isEmpty else { return }
        
        getAllBookmarks.execute { [weak self] in
            guard let self = self else { return }

            switch $0 {
            case .success(let bookmarkedGists):
                self.gists = bookmarkedGists
                self.gists = self.gists.uniques
                self.gists.sort {
                    $0.bookmarkedAt ?? Date() > $1.bookmarkedAt ?? Date()
                }
                let content = self.gists.map(self.mapGist)

                self.display?.displayDiscoveries(viewModel:
                    .content(
                        list: content,
                        hasMoreDataAvailable: false
                    )
                )
            case .failure(let error):
                let userError = ErrorHandler.userError(from: error)
                self.display?.displayDiscoveries(viewModel:
                    .failure(userError)
                )
            }

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

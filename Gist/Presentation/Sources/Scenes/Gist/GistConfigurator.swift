import UIKit

final class GistConfigurator {
    func resolve(with gist: GistDigest) -> UIViewController {

        let repository = FirebaseBookmarksRepository()
        let bookmarkGist = BookmarkGist(repository: repository)
        let presenter = GistPresenter(gist: gist, bookmarkGist: bookmarkGist)
        let viewController = GistTableViewController(presenter: presenter)

        presenter.display = viewController

        return viewController
    }
}

import UIKit

final class GistDetailsConfigurator {
    struct Dependencies {
        let gist: GistDigest
        let delegate: GistDetailsTableViewControllerDelegate?
    }

    func resolve(with dependencies: Dependencies) -> UIViewController {

        let repository = FirebaseBookmarksRepository()
        let bookmarkGist = BookmarkGist(repository: repository)
        let presenter = GistDetailsPresenter(
            gist: dependencies.gist,
            bookmarkGist: bookmarkGist
        )
        let viewController = GistDetailsTableViewController(presenter: presenter)

        viewController.delegate = dependencies.delegate
        presenter.display = viewController

        return viewController
    }
}

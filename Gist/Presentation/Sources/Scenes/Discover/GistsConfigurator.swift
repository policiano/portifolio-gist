import UIKit

final class GistsConfigurator {

    func resolve() -> UIViewController {
        let bookmarkRepository = FirebaseBookmarksRepository()
        let gistsRepository = MoyaGistsRepository(bookmarksRepository: bookmarkRepository)
        let getPublicGists = GetPublicGists(
            repository: gistsRepository
        )

        let bookmarkGist = BookmarkGist(repository: bookmarkRepository)

        let presenter = GistsPresenter(
            getPublicGists: getPublicGists, bookmarkGist: bookmarkGist
        )
        
        let router = GistsRouter(dataStore: presenter)
        let viewController = GistsTableViewController(presenter: presenter, router: router)

        presenter.display = viewController
        router.viewController = viewController

        return viewController
    }
}

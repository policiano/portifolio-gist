import UIKit

final class DiscoverConfigurator {

    func resolve() -> UIViewController {
        let bookmarkRepository = FirebaseBookmarksRepository()
        let gistsRepository = MoyaGistsRepository(bookmarksRepository: bookmarkRepository)
        let getPublicGists = GetPublicGists(
            repository: gistsRepository
        )

        let bookmarkGist = BookmarkGist(repository: bookmarkRepository)

        let presenter = DiscoverPresenter(
            getPublicGists: getPublicGists, bookmarkGist: bookmarkGist
        )
        
        let router = DiscoverRouter(dataStore: presenter)
        let viewController = DiscoverViewController(presenter: presenter, router: router)

        presenter.display = viewController
        router.viewController = viewController

        return viewController
    }
}

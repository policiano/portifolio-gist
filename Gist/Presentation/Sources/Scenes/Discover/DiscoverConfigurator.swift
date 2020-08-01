import UIKit

final class DiscoverConfigurator {

    func resolve() -> UIViewController {
        let bookmarkRepository = FirebaseBookmarksRepository.shared
        let gistsRepository = MoyaGistsRepository(bookmarksRepository: bookmarkRepository)
        let getPublicGists = GetPublicGists(
            repository: gistsRepository
        )

        let presenter = DiscoverPresenter(
            getPublicGists: getPublicGists
        )
        
        let router = DiscoverRouter(dataStore: presenter)
        let viewController = DiscoverViewController(presenter: presenter, router: router)

        presenter.display = viewController
        router.viewController = viewController

        return viewController
    }
}

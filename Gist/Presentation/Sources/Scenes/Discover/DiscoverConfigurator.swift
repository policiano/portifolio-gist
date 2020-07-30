import UIKit

final class DiscoverConfigurator {

    func resolve() -> UIViewController {
        let repository = MoyaGistsRepository()
        let getPublicGists = GetPublicGists(repository: repository)
        let getMorePublicGists = GetMorePublicGists(repository: repository)
        let presenter = DiscoverPresenter(
            getPublicGists: getPublicGists,
            getMorePublicGists: getMorePublicGists
        )
        
        let router = DiscoverRouter(dataStore: presenter)
        let viewController = DiscoverTableViewController(presenter: presenter, router: router)

        presenter.display = viewController
        router.viewController = viewController

        return viewController
    }
}

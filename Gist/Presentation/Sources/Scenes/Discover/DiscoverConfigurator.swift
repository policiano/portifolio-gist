import UIKit

final class DiscoverConfigurator {

    func resolve() -> UIViewController {
        let repository = MoyaGistsRepository()
        let getPublicGists = GetPublicGists(repository: repository)
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

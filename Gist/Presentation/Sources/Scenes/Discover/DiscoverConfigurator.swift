import UIKit

final class DiscoverConfigurator {

    func resolve() -> UIViewController {
        let repository = MoyaGistsRepository()
        let getPublicGists = GetPublicGists(repository: repository)
        let presenter = DiscoverPresenter(getPublicGists: getPublicGists)
        let viewController = DiscoverTableViewController(presenter: presenter)

        presenter.display = viewController

        return viewController
    }
}

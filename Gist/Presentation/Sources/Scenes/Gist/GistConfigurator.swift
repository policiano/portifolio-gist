import UIKit

final class GistConfigurator {
    func resolve(with gist: GistDigest) -> UIViewController {
        let presenter = GistPresenter(gist: gist)
        let viewController = GistTableViewController(presenter: presenter)

        presenter.display = viewController

        return viewController
    }
}

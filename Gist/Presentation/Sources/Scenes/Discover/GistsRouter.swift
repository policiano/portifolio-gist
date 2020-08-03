import UIKit

protocol GistsRoutingLogic {
    func routeToDigest(_ gist: GistDigestCell.ViewModel)
    func routeToBookmarks() 
}

protocol GistsDataPassing {
    var dataStore: GistsDataStore { get }
}

typealias GistsRouterType = GistsRoutingLogic & GistsDataPassing

final class GistsRouter: GistsDataPassing {
    let dataStore: GistsDataStore
    weak var viewController: UIViewController?

    init(dataStore: GistsDataStore) {
        self.dataStore = dataStore
    }
}

extension GistsRouter: GistsRoutingLogic {

    func routeToDigest(_ gist: GistDigestCell.ViewModel) {
        guard let selectedDigest = dataStore.gists.first(where: { $0.id == gist.id }) else {
            return
        }
        let delegate = viewController as? GistDetailsTableViewControllerDelegate
        let destination = GistDetailsConfigurator().resolve(
            with: .init(gist: selectedDigest, delegate: delegate)
        )

        let navigationController = UINavigationController(rootViewController: destination)
        viewController?.showDetailViewController(navigationController, sender: viewController)
    }

    func routeToBookmarks() {
        let bookmarksViewController = BookmarksConfigurator().resolve()
        viewController?.navigationController?.pushViewController(bookmarksViewController, animated: true)
    }
}

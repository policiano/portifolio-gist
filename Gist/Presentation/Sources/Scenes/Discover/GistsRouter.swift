import UIKit

protocol GistsRoutingLogic {
    func routeToDigest(forIndex index: Int)
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

    func routeToDigest(forIndex index: Int) {
        guard let selectedDigest = dataStore.gists[safeIndex: index] else {
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

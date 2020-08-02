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
        let delegate = viewController as? GistTableViewControllerDelegate
        let destinationViewController = GistConfigurator().resolve(with: selectedDigest, delegate: delegate)
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        viewController?.showDetailViewController(navigationController, sender: viewController)
    }

    func routeToBookmarks() {
        let bookmarksViewController = BookmarksConfigurator().resolve()
        viewController?.navigationController?.pushViewController(bookmarksViewController, animated: true)
    }
}

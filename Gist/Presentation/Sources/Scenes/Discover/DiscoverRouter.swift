import UIKit

protocol DiscoverRoutingLogic {
    func routeToDigest(forIndex index: Int)
}

protocol DiscoverDataPassing {
    var dataStore: DiscoverDataStore { get }
}

typealias DiscoverRouterType = DiscoverRoutingLogic & DiscoverDataPassing

final class DiscoverRouter: DiscoverRouterType {
    let dataStore: DiscoverDataStore

    init(dataStore: DiscoverDataStore) {
        self.dataStore = dataStore
    }

    weak var viewController: UIViewController?

    func routeToDigest(forIndex index: Int) {
        guard let selectedDigest = dataStore.gists[safeIndex: index] else {
            return
        }

        let destinationViewController = GistConfigurator().resolve(with: selectedDigest)
        let navigationController = UINavigationController(rootViewController: destinationViewController)
        viewController?.showDetailViewController(navigationController, sender: viewController)
    }
}

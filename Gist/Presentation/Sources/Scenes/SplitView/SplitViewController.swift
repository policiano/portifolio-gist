import UIKit

public final class SplitViewController: UISplitViewController {
    public override func viewDidLoad() {
        setupMasterAndDetail()

        preferredDisplayMode = .allVisible
    }
    
    private func setupMasterAndDetail() {
        let discoverViewController = DiscoverConfigurator().resolve()
        let master = UINavigationController(rootViewController: discoverViewController)

        viewControllers = [master]
    }
}


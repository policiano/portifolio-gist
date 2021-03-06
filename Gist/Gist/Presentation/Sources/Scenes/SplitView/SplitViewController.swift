import UIKit

public final class SplitViewController: UISplitViewController {
    public override func viewDidLoad() {
        setupMasterAndDetail()

        preferredDisplayMode = .allVisible
    }
    
    private func setupMasterAndDetail() {
        let gistsViewController = GistsConfigurator().resolve()
        let master = UINavigationController(rootViewController: gistsViewController)

        master.navigationBar.prefersLargeTitles = true

        viewControllers = [master]
    }
}


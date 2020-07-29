import UIKit

public final class SplitViewController: UISplitViewController {
    public override func viewDidLoad() {
        setupMasterAndDetail()

        preferredDisplayMode = .allVisible
    }
    
    private func setupMasterAndDetail() {
        let master = UINavigationController(rootViewController: DiscoverTableViewController())

        viewControllers = [master]
    }
}

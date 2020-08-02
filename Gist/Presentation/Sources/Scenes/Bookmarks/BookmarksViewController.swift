import UIKit

final class BookmarksViewController: DiscoverViewController {
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.rightBarButtonItem = nil
        title = "Bookmarks"
    }
}

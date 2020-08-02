import UIKit

final class BookmarksViewController: GistsTableViewController {
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.rightBarButtonItem = nil
        title = "Bookmarks"
    }
}

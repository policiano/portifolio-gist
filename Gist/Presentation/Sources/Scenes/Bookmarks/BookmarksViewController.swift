import UIKit

final class BookmarksViewController: GistsViewController {
    override func setNavigationBar() {
        super.setNavigationBar()
        navigationItem.rightBarButtonItem = nil
        title = "Bookmarks"
    }
}

import UIKit

extension UITableView {

    // Remove extra empty cells

    override open func didMoveToSuperview() {
        super.didMoveToSuperview()
        tableFooterView = UIView()
    }
}

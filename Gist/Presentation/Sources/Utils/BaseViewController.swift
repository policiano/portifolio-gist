import Anchorage
import UIKit

public protocol BaseController {
    var rootView: UIView { get }
}

extension BaseController where Self: UIViewController {
    func setup() {
        rootView.backgroundColor = .systemBackground
    }
}

public class BaseViewController: UIViewController, BaseController {

    public override func viewDidLoad() {
        setup()
    }

    public var rootView: UIView { view }
}

public class BaseTableViewController: UITableViewController, BaseController {

    public override func viewDidLoad() {
        setup()
    }

    public var rootView: UIView { tableView }
}

extension UITableView {
    func showError(title: String?, message: String?, action: ErrorStateView.Action) {
        let errorView = ErrorStateView()
        errorView.show(title: title, message: message, action: action)
        // The only tricky part is here:
        self.backgroundView = errorView
        self.separatorStyle = .none
    }

    func restore() {
        self.backgroundView = nil
        self.separatorStyle = .singleLine
    }
}

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

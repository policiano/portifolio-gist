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

public class BaseTableViewController: UITableViewController, BaseController, ErrorStateViewDelegate {

    public override func viewDidLoad() {
        setup()
    }

    public var rootView: UIView { tableView }

    func showError(title: String?, message: String?, buttonTitle: String) {
        let errorView = ErrorStateView()
        errorView.show(title: title, message: message, buttonTitle: buttonTitle)
        errorView.delegate = self

        tableView.backgroundView = errorView
        tableView.separatorStyle = .none
    }

    func showLoading() {
        let loadingView = UIView()
        loadingView.backgroundColor = .systemBackground

        let activityIndicatiorView = UIActivityIndicatorView(style: .large)
        activityIndicatiorView.startAnimating()

        loadingView.addSubview(activityIndicatiorView)

        activityIndicatiorView.centerAnchors == loadingView.centerAnchors

        tableView.backgroundView = loadingView
        tableView.separatorStyle = .none
    }

    func restore() {
        tableView.backgroundView = nil
        tableView.separatorStyle = .singleLine
    }

    // MARK: ErrorStateViewDelegate

    public func didTapOnActionButton(in errorStateView: ErrorStateView) {

    }
}

extension UITableView {
    func layoutTableHeaderView() {

        guard let headerView = self.tableHeaderView else { return }
        headerView.translatesAutoresizingMaskIntoConstraints = false

        let headerWidth = headerView.bounds.size.width
        let temporaryWidthConstraint = headerView.widthAnchor.constraint(equalToConstant: headerWidth)

        headerView.addConstraint(temporaryWidthConstraint)

        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()

        let headerSize = headerView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        let height = headerSize.height
        var frame = headerView.frame

        frame.size.height = height
        headerView.frame = frame

        self.tableHeaderView = headerView

        headerView.removeConstraint(temporaryWidthConstraint)
        headerView.translatesAutoresizingMaskIntoConstraints = true
    }

}

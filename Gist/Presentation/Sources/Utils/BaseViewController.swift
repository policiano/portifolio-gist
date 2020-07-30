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

public class BaseViewController: UIViewController, BaseController, ErrorStateViewDelegate {
    private let errorView = ErrorStateView()

    public override func viewDidLoad() {
        setup()
        setupErrorView()
    }

    public var rootView: UIView { view }

    private func setupErrorView() {
        rootView.addSubview(errorView)
        errorView.edgeAnchors == rootView.edgeAnchors
        errorView.isHidden = true
        rootView.sendSubviewToBack(errorView)
    }

    func showError(title: String?, message: String?, buttonTitle: String) {

        errorView.show(title: title, message: message, buttonTitle: buttonTitle)
        errorView.delegate = self
        rootView.bringSubviewToFront(errorView)
        errorView.isHidden = false
    }

    public func didTapOnActionButton(in errorStateView: ErrorStateView) {

    }
}

public class BaseTableViewController: UITableViewController, BaseController {

    public override func viewDidLoad() {
        setup()
    }

    public var rootView: UIView { tableView }
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

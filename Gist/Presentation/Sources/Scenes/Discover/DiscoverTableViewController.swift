import UIKit
import PaginatedTableView

protocol DiscoverDisplayLogic: AnyObject {
    func displayMoreDiscoveries(viewModel: Discover.GetMoreDiscoveries.ViewModel)
}

public final class DiscoverTableViewController: BaseViewController, CustomViewController {
    typealias View = PaginatedTableView

    private let presenter: DiscoverPresentationLogic
    private let router: DiscoverRoutingLogic

    init(
        presenter: DiscoverPresentationLogic,
        router: DiscoverRoutingLogic
    ) {
        self.presenter = presenter
        self.router = router
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    var viewModels: [GistDigestView.ViewModel] = []

    public override func loadView() {
        view = PaginatedTableView()
    }

    public override var rootView: UIView {
        customView
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true

        customView.loadData(refresh: true)
    }

    private func setupTableView() {
        customView.paginatedDelegate = self
        customView.paginatedDataSource = self
        customView.pageSize = 20
        customView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
    }

    private func getDiscoveries() {
        presenter.getMoreDiscoveries(request: .init())
    }

    public override func didTapOnActionButton(in errorStateView: ErrorStateView) {
        getDiscoveries()
    }

    var onSuccess: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
}

extension DiscoverTableViewController: PaginatedTableViewDataSource, PaginatedTableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }

    public func numberOfSections(in tableView: UITableView) -> Int { 1 }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = GistDigestCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }

        if isLoadingCell(for: indexPath) {
            cell.displayLoading()
        } else {
            let viewModel = viewModels[indexPath.row]
            cell.display(with: viewModel)
        }

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToDigest(forIndex: indexPath.row)
    }

    public func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            self.getDiscoveries()
        }

        self.onSuccess = onSuccess
        self.onError = onError
    }
}

// MARK: Infinite scrolling

private extension DiscoverTableViewController {
    func isLoadingCell(for indexPath: IndexPath) -> Bool {
        return indexPath.row >= viewModels.count && viewModels.count > 0
    }
}

// MARK: Display Logic

extension DiscoverTableViewController: DiscoverDisplayLogic {

    func displayMoreDiscoveries(viewModel: Discover.GetMoreDiscoveries.ViewModel) {
        switch viewModel {
        case .content(let list, let hasMoreDataAvailable):
            viewModels = list
            onSuccess?(hasMoreDataAvailable)
        case .failure(let userError):
            onError?(userError)
        }

    }
}

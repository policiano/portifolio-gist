import UIKit
import PaginatedTableView

protocol DiscoverDisplayLogic: AnyObject {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel)
}

public final class DiscoverViewController: UIViewController, CustomViewController {
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
        presenter.getDiscoveries(request: .init())
    }

    var onSuccess: ((Bool) -> Void)?
    var onError: ((Error) -> Void)?
}

extension DiscoverViewController: PaginatedTableViewDataSource, PaginatedTableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }

    public func numberOfSections(in tableView: UITableView) -> Int { 1 }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = GistDigestCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }

        let viewModel = viewModels[indexPath.row]
        cell.display(with: viewModel)

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToDigest(forIndex: indexPath.row)
    }

    public func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        let delay = pageNumber > 1 ? 2 : 0.5
        DispatchQueue.global().asyncAfter(deadline: .now() + delay) {
            self.getDiscoveries()
        }

        self.onSuccess = onSuccess
        self.onError = onError
    }
}

// MARK: Display Logic

extension DiscoverViewController: DiscoverDisplayLogic {

    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel) {
        switch viewModel {
        case .content(let list, let hasMoreDataAvailable):
            viewModels = list
            onSuccess?(hasMoreDataAvailable)
        case .failure(let userError):
            onError?(userError)
        }
    }
}

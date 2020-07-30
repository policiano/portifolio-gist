import UIKit

protocol DiscoverDisplayLogic: AnyObject {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel)
}

public final class DiscoverTableViewController: BaseTableViewController {

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

    var viewModels: [GistDigestView.ViewModel] = [] {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true

        getDiscoveries()
    }

    private func setupTableView() {
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
    }

    private func getDiscoveries() {
        showLoading()
        presenter.getDiscoveries(request: .init())
    }

    // MARK: TableView Delegate & DataSource

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = GistDigestCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }

        let viewModel = viewModels[indexPath.row]
        cell.display(with: viewModel)

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        router.routeToDigest(forIndex: indexPath.row)
    }

    public override func didTapOnActionButton(in errorStateView: ErrorStateView) {
        getDiscoveries()
    }
}

extension DiscoverTableViewController: DiscoverDisplayLogic {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel) {
        switch viewModel {
        case .content(let viewModels):
            restore()
            self.viewModels = viewModels
        case .failure(let error):
            self.viewModels = []

            showError(
                title: error.title,
                message: error.message,
                buttonTitle: "Try Again"
            )
        }
    }
}

import UIKit

protocol DiscoverDisplayLogic: AnyObject {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel)
    func displaySelectedGist(viewModel: Discover.SelectGist.ViewModel)
}

public final class DiscoverTableViewController: BaseTableViewController {

    private let presenter: DiscoverPresentationLogic

    init(presenter: DiscoverPresentationLogic) {
        self.presenter = presenter
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
        tableView.showLoading()
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
        presenter.selectGist(request: .init(index: indexPath.row))
    }
}

extension DiscoverTableViewController: DiscoverDisplayLogic {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel) {
        switch viewModel {
        case .content(let viewModels):
            tableView.restore()
            self.viewModels = viewModels
        case .failure(let error):
            self.viewModels = []

            tableView.showError(
                title: error.title,
                message: error.message,
                action: (
                    title: "Try Again",
                    handler: getDiscoveries
                )
            )
        }
    }

    func displaySelectedGist(viewModel: Discover.SelectGist.ViewModel) {
        let viewController = GistTableViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: viewController)
        showDetailViewController(navigationController, sender: self)
    }
}

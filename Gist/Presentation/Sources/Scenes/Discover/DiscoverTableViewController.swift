import UIKit

protocol DiscoverDisplayLogic: AnyObject {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel)
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
            tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()

        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    public override func viewWillAppear(_ animated: Bool) {
        getDiscoveries()
    }

    private func setupTableView() {
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
    }

    private func getDiscoveries() {
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
        let navigationController = UINavigationController(rootViewController: GistViewController())
        showDetailViewController(navigationController, sender: self)
    }
}

extension DiscoverTableViewController: DiscoverDisplayLogic {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel) {
        switch viewModel {
        case .content(let viewModels):
            tableView.restore()
            self.viewModels = viewModels
        case .failure(let error):
            let retry = { [weak self] in
                guard let self = self else { return }
                self.getDiscoveries()
            }

            self.viewModels = []

            tableView.showError(
                title: error.title,
                message: error.message,
                action: (
                    title: "Try Again",
                    handler: retry
                )
            )
        }
    }
}

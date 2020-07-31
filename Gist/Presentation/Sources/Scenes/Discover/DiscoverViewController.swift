import Anchorage
import UIKit
import PaginatedTableView
import StatefulViewController

protocol DiscoverDisplayLogic: AnyObject {
    func displayDiscoveries(viewModel: Discover.GetDiscoveries.ViewModel)
}

public final class DiscoverViewController: UIViewController, StatefulViewController {
    private let tableView = PaginatedTableView()
    private var viewModels: [GistDigestView.ViewModel] = []

    // MARK: Pagination

    private var onSuccess: ((Bool) -> Void)?
    private var onError: ((Error) -> Void)?

    // MARK: Object lifecycle

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

    // MARK: ViewController Lifecycle

    public override func loadView() {
        super.loadView()
        view.backgroundColor = .systemBackground
        setupTableView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        setupStateful()

        title = "Discover"
        navigationController?.navigationBar.prefersLargeTitles = true

        tableView.loadData(refresh: true)
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        setupInitialViewState()
        startLoading()
    }

    // MARK: Setup

    private func setupTableView() {
        view.addSubview(tableView)

        tableView.horizontalAnchors == view.horizontalAnchors
        tableView.topAnchor == view.safeAreaLayoutGuide.topAnchor
        tableView.bottomAnchor == view.bottomAnchor

        tableView.paginatedDelegate = self
        tableView.paginatedDataSource = self
        tableView.pageSize = 20
        tableView.loadMoreViewHeight = 60
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
    }

    // MARK: Stateful

    private lazy var errorStateView: ErrorView = {
        let view = ErrorView(frame: self.view.frame)
        view.tapGestureRecognizer.addTarget(self, action: #selector(getDiscoveries))
        return view
    }()

    private func setupStateful() {
        loadingView = LoadingView(frame: view.frame)
        emptyView = EmptyView(frame: view.frame)
        errorView = errorStateView
    }

    public func hasContent() -> Bool {
        return viewModels.count > 0
    }

    public func handleErrorWhenContentAvailable(_ error: Error) {
        let alertController = UIAlertController(title: "Ooops", message: "Something went wrong.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))

        // Adapting for iPad

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alertController, animated: true, completion: nil)
    }

    // MARK: UseCase

    @objc private func getDiscoveries() {
        presenter.getDiscoveries(request: .init())
    }
}

// MARK: PaginatedTable

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
        let delay = pageNumber > 1 ? 1.5 : 0.5
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
            endLoading(error: nil, completion: nil)
        case .failure(let userError):
            onError?(userError)
            errorStateView.show(userError, fromAnchor: self)
        }
    }
}

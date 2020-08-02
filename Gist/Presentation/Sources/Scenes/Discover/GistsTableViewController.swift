import Anchorage
import UIKit
import PaginatedTableView
import StatefulViewController

protocol GistsDisplayLogic: AnyObject {
    func displayGists(viewModel: Gists.GetGists.ViewModel)
    func updateSelectedGist(viewModel: Gists.CheckUpdates.ViewModel)
    func displayBookmark(viewModel: Gists.Bookmark.ViewModel)
}

public class GistsTableViewController: UIViewController, StatefulViewController {
    private let tableView = PaginatedTableView()
    private var viewModels: [GistDigestCell.ViewModel] = []
    private var selectedGist: GistDigestCell.ViewModel?

    // MARK: Pagination

    private var onSuccess: ((Bool) -> Void)?
    private var onError: ((Error) -> Void)?

    // MARK: Object lifecycle

    private let presenter: GistsPresentationLogic
    private let router: GistsRoutingLogic

    init(
        presenter: GistsPresentationLogic,
        router: GistsRoutingLogic
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
        setNavigationBar()
        setupStateful()

        tableView.loadData(refresh: true)
    }

    public func setNavigationBar() {
        title = "Gists"

        let bookmark = UIBarButtonItem(
            title: "Bookmarks",
            style: .plain,
            target: self,
            action: #selector(routeToBookmarks)
        )

        navigationItem.rightBarButtonItem = bookmark
        navigationController?.navigationBar.prefersLargeTitles = true
    }

    @objc func routeToBookmarks() {
        router.routeToBookmarks()
    }

    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if splitViewController?.isCollapsed == true {
            checkSelectedGistUpdates()
        }

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
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
    }

    // MARK: Stateful

    private lazy var errorStateView: ErrorView = {
        let view = ErrorView(frame: self.view.frame)
        view.tapGestureRecognizer.addTarget(self, action: #selector(getGists))
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

    private func updateAndReload(_ gist: GistDigestCell.ViewModel, at index: IndexPath) {
        viewModels[index.row] = gist
        selectedGist = gist
        tableView.reloadRows(at: [index], with: .fade)
    }

    private func refreshDetailView(with index: IndexPath) {
        if splitViewController?.isCollapsed == false {
            router.routeToDigest(forIndex: index.row)
        }
    }

    // MARK: UseCase

    @objc private func getGists() {
        presenter.getGists(request: .init())
    }

    private func checkSelectedGistUpdates() {
         presenter.checkSelectedGistUpdates(request: .init(selectedGist: selectedGist))
    }
}

// MARK: PaginatedTable

extension GistsTableViewController: PaginatedTableViewDataSource, PaginatedTableViewDelegate {

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
        cell.delegate = self

        return cell
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGist = viewModels[safeIndex: indexPath.row]
        router.routeToDigest(forIndex: indexPath.row)
    }

    public func loadMore(_ pageNumber: Int, _ pageSize: Int, onSuccess: ((Bool) -> Void)?, onError: ((Error) -> Void)?) {
        let delay = pageNumber > 1 ? 1.5 : 0.5
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.getGists()
        }

        self.onSuccess = onSuccess
        self.onError = onError
    }
}

extension GistsTableViewController: GistTableViewControllerDelegate {
    func didUpdateGist(at viewController: GistTableViewController) {
        checkSelectedGistUpdates()
    }
}

extension GistsTableViewController: GistDigestCellDelegate {
    func bookmarkDidTap(_ cell: GistDigestCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let gist = viewModels[safeIndex: indexPath.row] else {
                return
        }

        presenter.bookmark(request: .init(index: indexPath, gist: gist))
    }
}

// MARK: Display Logic

extension GistsTableViewController: GistsDisplayLogic {
    func displayBookmark(viewModel: Gists.Bookmark.ViewModel) {
        updateAndReload(viewModel.bookmarkedGist, at: viewModel.index)
        refreshDetailView(with: viewModel.index)
    }

    func updateSelectedGist(viewModel: Gists.CheckUpdates.ViewModel) {
        updateAndReload(viewModel.selectedGist, at: viewModel.index)
    }

    func displayGists(viewModel: Gists.GetGists.ViewModel) {
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

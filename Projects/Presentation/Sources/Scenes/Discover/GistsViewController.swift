import Anchorage
import UIKit

protocol GistsDisplayLogic: AnyObject {
    func displayGists(viewModel: Gists.GetGists.ViewModel)
    func updateSelectedGist(viewModel: Gists.CheckUpdates.ViewModel)
    func displayBookmark(viewModel: Gists.Bookmark.ViewModel)
}

public class GistsViewController: UIViewController, StatefulViewController {
    let tableView = PaginatedTableView()
    private let searchController = UISearchController(searchResultsController: nil)
    private var allGists: [GistDigestCell.ViewModel] = []
    private var filteredGists: [GistDigestCell.ViewModel] = []
    private var selectedGist: GistDigestCell.ViewModel?

    private var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private var viewModels: [GistDigestCell.ViewModel] {
        if isFiltering {
            return filteredGists
        }
        return allGists
    }

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
        setSearchController()
        setupStateful()

        tableView.loadData(refresh: true)
    }

    public func setSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Users"

        navigationItem.searchController = searchController
        definesPresentationContext = true
    }

    public func setNavigationBar() {
        title = L10n.GistList.title

        let bookmark = UIBarButtonItem(
            title: L10n.Bookmarks.title,
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

    public override func viewWillDisappear(_ animated: Bool) {
        searchController.isActive = false
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
        let alertController = UIAlertController(
            title: L10n.Error.Content.title,
            message: L10n.Error.Content.message,
            preferredStyle: .alert
        )
        let action = UIAlertAction(title: L10n.General.ok, style: .default, handler: nil)
        alertController.addAction(action)

        // Adapting for iPad

        if let popoverController = alertController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        present(alertController, animated: true, completion: nil)
    }

    private func updateAndReload(_ gist: GistDigestCell.ViewModel, at index: IndexPath) {
        if isFiltering {
            filteredGists[index.row] = gist
        } else {
            allGists[index.row] = gist
        }

        selectedGist = gist
        tableView.reloadRows(at: [index], with: .fade)
    }

    private func refreshDetailView(with index: IndexPath) {
        if splitViewController?.isCollapsed == false, let gist = viewModels[safeIndex: index.row] {
            router.routeToDigest(gist)
        }
    }

    // MARK: UseCase

    @objc private func getGists() {
        presenter.getGists(request: .init())
    }

    private func checkSelectedGistUpdates() {
         presenter.checkSelectedGistUpdates(request: .init(selectedGist: selectedGist))
    }

    func filterContentForSearchText(_ searchText: String) {
        filteredGists = allGists.filter { $0.ownerName.lowercased().contains(searchText.lowercased()) }
        startLoading()
        tableView.reloadData()
        endLoading(animated: true, error: nil, completion: nil)
    }

    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }

    func getIndexOf(gist: GistDigestCell.ViewModel) -> IndexPath? {
        let offset = viewModels.enumerated().first {
            $1.id == gist.id
            }?.offset

        guard let row = offset else {
            return nil
        }

        return IndexPath(row: row, section: 0)
    }
}

// MARK: PaginatedTable

extension GistsViewController: PaginatedTableViewDataSource, PaginatedTableViewDelegate {

    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { UITableView.automaticDimension }

    public func numberOfSections(in tableView: UITableView) -> Int { 1 }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModels.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return GistDigestCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) {
            let viewModel = self.viewModels[indexPath.row]
            $0.display(with: viewModel)
            $0.delegate = self
        }
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedGist = viewModels[safeIndex: indexPath.row]
        if let gist = selectedGist {
            router.routeToDigest(gist)
        }
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

extension GistsViewController: GistDetailsTableViewControllerDelegate {
    func didUpdateGist(at viewController: GistDetailsTableViewController) {
        checkSelectedGistUpdates()
    }
}

extension GistsViewController: GistDigestCellDelegate {
    func bookmarkDidTap(_ cell: GistDigestCell) {
        guard let indexPath = tableView.indexPath(for: cell),
            let gist = viewModels[safeIndex: indexPath.row] else {
                return
        }

        presenter.bookmark(request: .init(gist: gist))
    }
}

// MARK: Search

extension GistsViewController: UISearchResultsUpdating {
    public func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        guard let text = searchBar.text else {
            return
        }
        filterContentForSearchText(text)
    }
}

// MARK: Display Logic

extension GistsViewController: GistsDisplayLogic {

    func displayBookmark(viewModel: Gists.Bookmark.ViewModel) {
        let gist = viewModel.bookmarkedGist
        guard let indexPath = getIndexOf(gist: gist) else { return }
        
        updateAndReload(gist, at: indexPath)
        refreshDetailView(with: indexPath)
    }

    func updateSelectedGist(viewModel: Gists.CheckUpdates.ViewModel) {
        let gist = viewModel.selectedGist
        guard let indexPath = getIndexOf(gist: gist) else { return }

        updateAndReload(viewModel.selectedGist, at: indexPath)
    }

    func displayGists(viewModel: Gists.GetGists.ViewModel) {
        switch viewModel {
        case .content(let list, let hasMoreDataAvailable):
            allGists = list
            onSuccess?(hasMoreDataAvailable)
            endLoading(error: nil, completion: nil)
        case .failure(let userError):
            onError?(userError)
            errorStateView.show(userError, fromAnchor: self)
        }
    }
}

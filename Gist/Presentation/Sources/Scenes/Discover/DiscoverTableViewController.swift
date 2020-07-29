import UIKit

public final class DiscoverTableViewController: BaseTableViewController {
    let repository = MoyaGistsRepository()

    var models: [GistDigest] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()

        title = "Discover"

        GetPublicGists(repository: MoyaGistsRepository()).execute { [weak self] in
            self?.models = $0.value ?? []
        }
    }

    private func registerCells() {
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = GistDigestCell.dequeued(fromTableView: tableView) else {
            return UITableViewCell()
        }
        let files = [
            "application/json",
            "text/plain",
            "text/html",
            "image/jpeg",
            "image/png",
            "audio/mpeg",
            "audio/ogg",
            "video/mp4",
            "application/octet-stream"
        ]

        let headerViewModel = GistDigestView.ViewModel(
            avatarUrl: URL(string: "https://avatars2.githubusercontent.com/u/50024899?v=4"),
            ownerName: "emanuel-jose",
            secondaryText: "Created 18 minutes ago",
            fileTypes: Array(files.prefix(4))
        )

        cell.display(with: headerViewModel)

        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = UINavigationController(rootViewController: GistViewController())
        showDetailViewController(navigationController, sender: self)
    }
}

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
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }
        let item = models[indexPath.row]
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = "\(item.owner.name) * \(item.files.first?.name ?? "")\n\n\(item.description ?? "")"
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navigationController = UINavigationController(rootViewController: GistViewController())
        showDetailViewController(navigationController, sender: self)
    }
}

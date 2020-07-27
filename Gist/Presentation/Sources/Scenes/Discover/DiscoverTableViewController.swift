import UIKit

public final class DiscoverTableViewController: BaseTableViewController {
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerCells()

        title = "Discover"
    }

    private func registerCells() {
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") else {
            return UITableViewCell()
        }

        cell.textLabel?.text = "Fist item"
        return cell
    }

    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showDetailViewController(GistViewController(), sender: self)
    }
}

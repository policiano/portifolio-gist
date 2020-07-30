import UIKit

public final class GistTableViewController: BaseTableViewController {
    enum Section: Int {
        case description = 0
        case files = 1

        var title: String {
            switch self {
            case .description:
                return "Description"
            case .files:
                return "Files"
            }
        }
    }

    private let headerView = GistDigestView()

    private let viewModel: GistView.ViewModel

    init(viewModel: GistView.ViewModel) {
        self.viewModel = viewModel
        super.init(style: .grouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    public override func viewDidLoad() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        setupTableView()
        tableView.reloadData()
    }

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        tableView.layoutTableHeaderView()
    }

    private func setupTableView() {
        updateHeaderWith(viewModel.headerViewModel)

        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
    }

    private func updateHeaderWith(_ viewModel: GistDigestView.ViewModel) {
        headerView.display(with: viewModel)
        tableView.tableHeaderView = headerView
        tableView.layoutTableHeaderView()
    }

    public override func numberOfSections(in tableView: UITableView) -> Int {
        viewModel.description != nil ? 2 : 1
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch Section(rawValue: section) {
        case .description:
            return 1
        case .files:
            return viewModel.files.count
        case .none:
            return 0
        }
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = UITableViewCell.dequeued(fromTableView: tableView, atIndexPath: indexPath),
            let section = Section(rawValue: indexPath.section) else {
                return UITableViewCell()
        }

        switch section {
        case .description:
            cell.selectionStyle = .none
            cell.textLabel?.text = viewModel.description
            cell.textLabel?.numberOfLines = 0
        case .files:
            cell.selectionStyle = .default
            cell.textLabel?.text = viewModel.files[safeIndex: indexPath.row]
            cell.accessoryType = .disclosureIndicator

            let font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
            let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)
            cell.textLabel?.font = fontMetrics.scaledFont(for: font)
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel?.textColor = .systemBlue
        }

        return cell
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        Section(rawValue: section)?.title
    }
}


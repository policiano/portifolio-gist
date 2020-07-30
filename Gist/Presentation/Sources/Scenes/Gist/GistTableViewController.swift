import UIKit

protocol GistDisplayLogic: AnyObject {
    func displayDetails(viewModel: Gist.GetDetails.ViewModel)
}

final class GistTableViewController: BaseTableViewController {

    private let headerView: GistDigestView = {
        let header = GistDigestView()
        header.backgroundColor = .systemBackground
        return header
    }()

    private var viewModel: ViewModel = .error {
        didSet {
            tableView.reloadData()
        }
    }

    private var header: HeaderViewModel? {
        if case .content(let header, _) = viewModel {
            return header
        }
        return nil
    }

    private var sections: [Section] {
        if case .content(_, let sections) = viewModel {
            return sections
        }
        return []
    }

    // MARK: Object lifecycle

    private let presenter: GistPresentationLogic

    init(presenter: GistPresentationLogic) {
        self.presenter = presenter
        super.init(style: .grouped)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    // MARK: ViewController lifecycle

    override func viewDidLoad() {
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        setupTableView()
        presenter.getDetails(request: .init())
    }

    // MARK: Private helpers

    private func setupTableView() {
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.estimatedRowHeight = 40
        tableView.rowHeight = UITableView.automaticDimension
    }

//    private func updateHeaderWith(_ viewModel: GistDigestView.ViewModel) {
//        headerView.display(with: viewModel)
//        tableView.tableHeaderView = headerView
//        tableView.setNeedsDisplay()
//        tableView.layoutTableHeaderView()
//    }

    // MARK: TableView Delegate & DataSource

    override func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }

    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].rows.count
    }

    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard var cell = UITableViewCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) else {
            return UITableViewCell()
        }

        let section = sections[indexPath.section]

        switch section.descriptor {
        case .header:
            guard let gistDigestCell = GistDigestCell.dequeued(fromTableView: tableView, atIndexPath: indexPath),
                let header = header else {
                return UITableViewCell()
            }
            gistDigestCell.display(with: header)
            cell = gistDigestCell
        case .description:
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
        case .files:
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator

            let font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
            let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)
            cell.textLabel?.font = fontMetrics.scaledFont(for: font)
            cell.textLabel?.adjustsFontForContentSizeCategory = true
            cell.textLabel?.textColor = .systemBlue
        }

        cell.textLabel?.text = section.rows[indexPath.row].title

        return cell
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let descriptor = sections[section].descriptor
        if descriptor == .header {
            return nil
        }
        return descriptor.rawValue
    }
}

extension GistTableViewController: GistDisplayLogic {
    func displayDetails(viewModel: Gist.GetDetails.ViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: ViewModel

extension GistTableViewController {
    typealias HeaderViewModel = GistDigestView.ViewModel
    struct Section {
        enum Descriptor: String {
            case header
            case description
            case files
        }

        struct Row {
            let title: String
        }

        let descriptor: Descriptor
        let rows: [Row]
    }

    enum ViewModel {
        case content(header: HeaderViewModel, sections: [Section])
        case error
    }
}


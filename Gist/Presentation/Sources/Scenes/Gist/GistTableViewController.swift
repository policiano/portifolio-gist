import UIKit

protocol GistDisplayLogic: AnyObject {
    func displayDetails(viewModel: Gist.GetDetails.ViewModel)
    func displayBookmark(viewModel: Gist.Bookmark.ViewModel)
}

final class GistTableViewController: UITableViewController {

    private var viewModel: ViewModel = .error {
        didSet {
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
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
        title = "Gist"
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        setupTableView()
        presenter.getDetails(request: .init())
    }

    // MARK: Private helpers

    private func setupTableView() {
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: UITableViewCell.identifier)
        tableView.estimatedRowHeight = 92
        tableView.rowHeight = UITableView.automaticDimension
    }

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
            gistDigestCell.delegate = self
            cell = gistDigestCell
            return cell
        case .description:
            cell.selectionStyle = .none
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.font = .preferredFont(forTextStyle: .caption1)
            cell.textLabel?.textColor = .label
        case .files:
            cell.selectionStyle = .default
            cell.accessoryType = .disclosureIndicator

            let font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)
            let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)
            cell.textLabel?.font = fontMetrics.scaledFont(for: font)
            cell.textLabel?.textColor = .systemBlue
        }

        cell.textLabel?.adjustsFontForContentSizeCategory = true
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

extension GistTableViewController: GistDigestCellDelegate {
    func bookmarkDidTap(_ cell: GistDigestCell) {
        presenter.bookmark(request: .init())
    }
}

extension GistTableViewController: GistDisplayLogic {
    func displayBookmark(viewModel: Gist.Bookmark.ViewModel) {
        self.viewModel = viewModel
    }

    func displayDetails(viewModel: Gist.GetDetails.ViewModel) {
        self.viewModel = viewModel
    }
}

// MARK: ViewModel

extension GistTableViewController {
    typealias HeaderViewModel = GistDigestCell.ViewModel

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


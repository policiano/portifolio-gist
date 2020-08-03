import Device
import UIKit
import WebKit

protocol GistDetailsDisplayLogic: AnyObject {
    func displayDetails(viewModel: GistDetails.GetDetails.ViewModel)
    func displayBookmark(viewModel: GistDetails.Bookmark.ViewModel)
}

protocol GistDetailsTableViewControllerDelegate: AnyObject {
    func didUpdateGist(at viewController: GistDetailsTableViewController)
}

final class GistDetailsTableViewController: UITableViewController {

    weak var delegate: GistDetailsTableViewControllerDelegate?
    private var webviewHeight: CGFloat = 0.0

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
        title = L10n.GistDetails.title
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        presenter.getDetails(request: .init())
    }

    // MARK: Private helpers

    private func setupTableView() {
        tableView.register(GistDigestCell.self, forCellReuseIdentifier: GistDigestCell.identifier)
        tableView.register(SnippetsCell.self, forCellReuseIdentifier: SnippetsCell.identifier)

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

        let section = sections[indexPath.section]
        let text = section.rows[indexPath.row].title
        switch section.descriptor {
        case .header:
            guard let header = header else {
                return UITableViewCell()
            }
            return GistDigestCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) {
                $0.display(with: header)
                $0.delegate = self
            }
        case .description:
            return UITableViewCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) {
                $0.selectionStyle = .none
                $0.textLabel?.numberOfLines = 0
                $0.textLabel?.font = .preferredFont(forTextStyle: .body)
                $0.textLabel?.textColor = .label
                $0.textLabel?.adjustsFontForContentSizeCategory = true
                $0.textLabel?.text = text
            }
        case .files:
            if Device.isIpad {
                return SnippetsCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) {
                    $0.displayWith(snippetPath: text, height: self.webviewHeight)
                    $0.delegate = self
                }
            }

            return UITableViewCell.dequeued(fromTableView: tableView, atIndexPath: indexPath) {
                let fontMetrics = UIFontMetrics(forTextStyle: .subheadline)
                let font = UIFont.monospacedSystemFont(ofSize: 14, weight: .semibold)

                $0.selectionStyle = .default
                $0.accessoryType = .disclosureIndicator
                $0.textLabel?.font = fontMetrics.scaledFont(for: font)
                $0.textLabel?.textColor = .systemBlue
                $0.textLabel?.text = text
            }
        }
    }

    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let descriptor = sections[section].descriptor
        if descriptor == .header {
            return nil
        }
        return descriptor.rawValue
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let descriptor = sections[indexPath.section].descriptor
        if descriptor == .files {
            return Device.isIpad ? webviewHeight : 45
        }
        return UITableView.automaticDimension
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let path = sections[indexPath.section].rows[indexPath.row].path
        let snippetViewController = SnippetViewController(snippetPath: path)
        navigationController?.pushViewController(snippetViewController, animated: true)
    }
}

extension GistDetailsTableViewController: GistDigestCellDelegate {
    func bookmarkDidTap(_ cell: GistDigestCell) {
        presenter.bookmark(request: .init())
    }
}

extension GistDetailsTableViewController: GistDetailsDisplayLogic {
    func displayBookmark(viewModel: GistDetails.Bookmark.ViewModel) {
        self.viewModel = viewModel
        if splitViewController?.isCollapsed == false {
            delegate?.didUpdateGist(at: self)
        }
    }

    func displayDetails(viewModel: GistDetails.GetDetails.ViewModel) {
        self.viewModel = viewModel
    }
}

extension GistDetailsTableViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        if webviewHeight != 0.0 {
            return
        }

        webView.evaluateJavaScript("document.readyState") { (complete, _) in
            guard complete != nil else { return }

            webView.evaluateJavaScript("document.body.scrollHeight") { (height, _) in
                self.webviewHeight = height as? CGFloat ?? 0
                self.tableView.reloadRows(at: [.init(row: 0, section: 2)], with: .none)
            }
        }
    }
}

// MARK: ViewModel

extension GistDetailsTableViewController {
    typealias HeaderViewModel = GistDigestCell.ViewModel

    struct Section {
        enum Descriptor: String {
            case header
            case description
            case files
        }

        struct Row {
            let title: String
            let path: String
        }

        let descriptor: Descriptor
        let rows: [Row]
    }

    enum ViewModel {
        case content(header: HeaderViewModel, sections: [Section])
        case error
    }
}


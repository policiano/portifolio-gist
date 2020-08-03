import Anchorage
import UIKit
import WebKit

final class SnippetsCell: UITableViewCell {
    private let webView = WKWebView()

    weak var delegate: WKNavigationDelegate? {
        get { webView.navigationDelegate }

        set { webView.navigationDelegate = newValue }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    private func setup() {
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(webView)
        webView.verticalAnchors == contentView.verticalAnchors
        webView.horizontalAnchors == contentView.horizontalAnchors + 8
    }
}

extension SnippetsCell {
    func displayWith(snippetPath: String, height: CGFloat) {
        webView.loadHTMLString(snippetPath, baseURL: nil)
    }
}

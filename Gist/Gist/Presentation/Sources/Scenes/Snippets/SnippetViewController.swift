import Anchorage
import Foundation
import WebKit

class SnippetViewController: UIViewController {
    private let webView = WKWebView()
    private let snippetPath: String

    init(snippetPath: String) {
        self.snippetPath = snippetPath
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    override func viewDidLoad() {
        title = "Snippet"
        setup()
    }

    private func setup() {
        view.addSubview(webView)
        webView.edgeAnchors == view.edgeAnchors
        webView.loadHTMLString(snippetPath, baseURL: nil)
    }
}

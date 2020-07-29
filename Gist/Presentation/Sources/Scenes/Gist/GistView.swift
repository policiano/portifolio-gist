import Anchorage
import Kingfisher
import UIKit

final class GistView: BaseView {
    private let containerView = UIView()
    private let headerView = GistDigestView()

    override func setup() {
        containerView.backgroundColor = .systemGroupedBackground

        setupScrollView()
        setupHeaderView()
    }

    private func setupScrollView() {
        let scrollView = UIScrollView()
        addSubview(scrollView)
        scrollView.edgeAnchors == safeAreaLayoutGuide.edgeAnchors

        scrollView.addSubview(containerView)

        containerView.edgeAnchors == safeAreaLayoutGuide.edgeAnchors
    }

    private func setupHeaderView() {
        containerView.addSubview(headerView)

        headerView.horizontalAnchors == containerView.horizontalAnchors + 16
        headerView.topAnchor == containerView.topAnchor + 24
    }
}

extension GistView {
    struct ViewModel {
        let headerViewModel: GistDigestView.ViewModel
        let description: String?
        let files: [String]
    }

    func display(with viewModel: ViewModel) {
        headerView.display(with: viewModel.headerViewModel)
    }
}

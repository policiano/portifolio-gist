import Anchorage
import UIKit

final class GistDigestCell: UITableViewCell {
    private let gistDigestView = GistDigestView()
    private let activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView(style: .large)
        view.startAnimating()
        return view
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    override func prepareForReuse() {
        gistDigestView.prepareForReuse()
        activityIndicator.isHidden = true
        gistDigestView.isHidden = false
    }

    private func setup() {
        let stackView = StackViewBuilder {
            $0.arrangedSubviews = [gistDigestView, activityIndicator]
        }.build()

        contentView.addSubview(stackView)
        stackView.edgeAnchors == contentView.edgeAnchors
        stackView.heightAnchor >= 60
        activityIndicator.centerAnchors == contentView.centerAnchors
    }
}

extension GistDigestCell {
    func display(with viewModel: GistDigestView.ViewModel) {
        gistDigestView.display(with: viewModel)
        activityIndicator.isHidden = true
        gistDigestView.isHidden = false

        contentView.layoutIfNeeded()
    }

    func displayLoading() {
        activityIndicator.isHidden = false
        gistDigestView.isHidden = true

        contentView.layoutIfNeeded()
    }
}

import Anchorage
import UIKit

final class GistDigestCell: UITableViewCell {
    private let gistDigestView = GistDigestView()
    
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
    }

    private func setup() {
        contentView.addSubview(gistDigestView)
        gistDigestView.edgeAnchors == contentView.edgeAnchors
    }
}

extension GistDigestCell {
    func display(with viewModel: GistDigestView.ViewModel) {
        gistDigestView.display(with: viewModel)
    }
}

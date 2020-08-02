import Anchorage
import Kingfisher
import TagListView
import UIKit

protocol GistDigestCellDelegate: AnyObject {
    func bookmarkDidTap(_ cell: GistDigestCell)
}

final class GistDigestCell: UITableViewCell {

    weak var delegate: GistDigestCellDelegate?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        nil
    }

    private let tagList = TagListView()

    private lazy var avatarContainer: UIView = {
        let view = UIView()
        view.addSubview(avatarImageView)
        return view
    }()

    private let avatarImageView: UIImageView = {
        let imageView = UIImageView(frame: .init(x: 0, y: 0, width: 60, height: 60))
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        imageView.setContentCompressionResistancePriority(.required, for: .vertical)
        imageView.kf.indicatorType = .activity
        return imageView
    }()

    private let ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 0
        label.textColor = .label
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private let secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .subheadline)
        label.adjustsFontForContentSizeCategory = true
        label.numberOfLines = 3
        label.textColor = .secondaryLabel
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        return label
    }()

    private lazy var containerView: UIStackView = {
        StackViewBuilder {
            let stackView = StackViewBuilder {
                let stackView = StackViewBuilder {
                    $0.spacing = 4
                    $0.alignment = .leading
                    $0.arrangedSubviews = [ownerNameLabel, secondaryLabel]
                }.build()

                $0.distribution = .fill
                $0.spacing = 8
                $0.arrangedSubviews = [stackView, tagList]
            }.build()

            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .top
            $0.distribution = .fillProportionally
            $0.arrangedSubviews = [avatarContainer, stackView]
        }.build()
    }()

    private lazy var bookmarkButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "bookmark"), for: .normal)
        button.setImage(UIImage(systemName: "bookmark.fill"), for: .selected)
        button.addTarget(self, action: #selector(bookmarkButtonTapped), for: .touchUpInside)
        return button
    }()

    // MARK: Subviews setup

    func setup() {
        setupAvatar()
        setupTagList()
        setupContainer()
    }

    override func prepareForReuse() {
        avatarImageView.image = nil
        ownerNameLabel.text = nil
        secondaryLabel.text = nil
        tagList.removeAllTags()
    }

    private func setupAvatar() {
        avatarImageView.widthAnchor == 60
        avatarImageView.heightAnchor == avatarImageView.widthAnchor
        avatarImageView.horizontalAnchors == avatarContainer.horizontalAnchors
        avatarImageView.topAnchor == avatarContainer.topAnchor
    }

    private func setupContainer() {
        contentView.addSubview(containerView)
        contentView.addSubview(bookmarkButton)
        bookmarkButton.heightAnchor == 40
        bookmarkButton.widthAnchor == 40
        bookmarkButton.topAnchor == contentView.topAnchor + 16
        bookmarkButton.trailingAnchor == contentView.trailingAnchor - 8

        bookmarkButton.leadingAnchor == containerView.trailingAnchor + 8
        containerView.leadingAnchor == contentView.leadingAnchor + 16
        containerView.verticalAnchors == contentView.verticalAnchors + 16
    }

    private func setupTagList() {
        tagList.textFont = UIFont.preferredFont(forTextStyle: .caption2)
        tagList.tagBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        tagList.borderColor = UIColor.systemBlue.withAlphaComponent(0.2)
        tagList.textColor = .systemBlue
        tagList.cornerRadius = 3
        tagList.borderWidth = 1
        tagList.paddingY = 4
        tagList.paddingX = 6
    }

    @objc private func bookmarkButtonTapped() {
        delegate?.bookmarkDidTap(self)
    }
}

extension GistDigestCell {
    struct ViewModel {
        let id: String
        let avatarUrl: URL?
        let ownerName: String
        let secondaryText: String?
        let fileTags: [String]
        var isBookmarked: Bool
    }

    func display(with viewModel: ViewModel) {
        prepareForReuse()

        ownerNameLabel.text = viewModel.ownerName
        secondaryLabel.text = viewModel.secondaryText
        secondaryLabel.isHidden = viewModel.secondaryText == nil
        bookmarkButton.isSelected = viewModel.isBookmarked

        tagList.removeAllTags()

        for tag in viewModel.fileTags {
            tagList.addTag(tag)
        }

        contentView.layoutIfNeeded()

        guard let url = viewModel.avatarUrl else {
            return
        }

        DispatchQueue.main.async {
            self.avatarImageView.kf.setImage(with: url, options: [.transition(.fade(0.3))])
        }
    }
}

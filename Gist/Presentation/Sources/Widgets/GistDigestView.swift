import Anchorage
import Kingfisher
import TagListView
import UIKit

final class GistDigestView: BaseView {
    let tagList = TagListView()

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

    override func setup() {
        setupAvatar()
        setupTagList()
        setupContainer()
    }

    func prepareForReuse() {
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
        addSubview(containerView)
        addSubview(bookmarkButton)
        bookmarkButton.heightAnchor == 40
        bookmarkButton.widthAnchor == 40
        bookmarkButton.topAnchor == topAnchor + 16
        bookmarkButton.trailingAnchor == trailingAnchor - 8

        bookmarkButton.leadingAnchor == containerView.trailingAnchor + 8
        containerView.leadingAnchor == leadingAnchor + 16
        containerView.verticalAnchors == verticalAnchors + 16
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
        bookmarkButton.isSelected.toggle()
    }
}

extension GistDigestView {
    struct ViewModel {
        let avatarUrl: URL?
        let ownerName: String
        let secondaryText: String?
        let fileTags: [String]
    }

    func display(with viewModel: ViewModel) {
        prepareForReuse()

        ownerNameLabel.text = viewModel.ownerName
        secondaryLabel.text = viewModel.secondaryText
        secondaryLabel.isHidden = viewModel.secondaryText == nil

        tagList.removeAllTags()

        for tag in viewModel.fileTags {
            tagList.addTag(tag)
        }

        layoutIfNeeded()

        guard let url = viewModel.avatarUrl else {
            return
        }

        DispatchQueue.main.async {
            self.avatarImageView.kf.setImage(with: url)
        }
    }
}

extension GistDigestView.ViewModel: Equatable {
    static func == (lhs: GistDigestView.ViewModel, rhs: GistDigestView.ViewModel) -> Bool {
        lhs.avatarUrl == rhs.avatarUrl
            && lhs.ownerName == rhs.ownerName
            && lhs.secondaryText == rhs.secondaryText
            && lhs.fileTags == rhs.fileTags
    }
}




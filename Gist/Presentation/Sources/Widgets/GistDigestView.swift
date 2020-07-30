import Anchorage
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

                $0.spacing = 8
                $0.arrangedSubviews = [stackView, tagList]
            }.build()

            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
            $0.distribution = .fillProportionally
            $0.arrangedSubviews = [avatarContainer, stackView]
        }.build()
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
        avatarImageView.edgeAnchors >= avatarContainer.edgeAnchors
        avatarImageView.centerAnchors == avatarContainer.centerAnchors
    }

    private func setupContainer() {
        addSubview(containerView)
        containerView.edgeAnchors == edgeAnchors + 16
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
}

extension GistDigestView {
    struct ViewModel {
        let avatarUrl: URL?
        let ownerName: String
        let secondaryText: String?
        let fileTypes: [String]
    }

    func display(with viewModel: ViewModel) {
        prepareForReuse()

        if let url = viewModel.avatarUrl {
            avatarImageView.kf.setImage(with: url)
        }

        ownerNameLabel.text = viewModel.ownerName
        secondaryLabel.text = viewModel.secondaryText
        secondaryLabel.isHidden = viewModel.secondaryText == nil

        tagList.removeAllTags()

        for file in viewModel.fileTypes {
            tagList.addTag(file)
        }
    }
}

extension GistDigestView.ViewModel: Equatable {
    static func == (lhs: GistDigestView.ViewModel, rhs: GistDigestView.ViewModel) -> Bool {
        lhs.avatarUrl == rhs.avatarUrl
            && lhs.ownerName == rhs.ownerName
            && lhs.secondaryText == rhs.secondaryText
            && lhs.fileTypes == rhs.fileTypes
    }
}




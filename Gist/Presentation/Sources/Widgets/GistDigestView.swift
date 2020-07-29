import Anchorage
import TagListView
import UIKit

final class GistDigestView: BaseView {
    let tagList = TagListView()

    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.layer.cornerRadius = 30
        imageView.layer.masksToBounds = true
        return imageView
    }()

    private lazy var ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private lazy var secondaryLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()

    private lazy var containerView: UIStackView = {
        StackViewBuilder {
            let stackView = StackViewBuilder {
                let stackView = StackViewBuilder {
                    $0.spacing = 4
                    $0.arrangedSubviews = [ownerNameLabel, secondaryLabel]
                }.build()

                $0.spacing = 8
                $0.arrangedSubviews = [stackView, tagList]
            }.build()

            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
            $0.arrangedSubviews = [avatarImageView, stackView]
        }.build()
    }()

    // MARK: Subviews setup

    override func setup() {
        backgroundColor = .systemBackground
        containerView.backgroundColor = .systemBackground

        setupAvatar()
        setupContainer()
        setupTagList()
    }

    private func setupAvatar() {
        avatarImageView.heightAnchor == 60
        avatarImageView.widthAnchor == 60
    }

    private func setupContainer() {
        addSubview(containerView)
        containerView.edgeAnchors == edgeAnchors + 16
    }

    private func setupTagList() {
        tagList.tagBackgroundColor = UIColor.systemBlue.withAlphaComponent(0.1)
        tagList.cornerRadius = 3
        tagList.borderWidth = 1
        tagList.borderColor = UIColor.systemBlue.withAlphaComponent(0.2)
        tagList.textColor = .systemBlue
        tagList.paddingY = 4
        tagList.paddingX = 6
    }
}

extension GistDigestView {
    struct ViewModel {
        let avatarUrl: URL?
        let ownerName: String
        let secondaryText: String
        let fileTypes: [String]
    }

    func display(with viewModel: ViewModel) {
        if let url = viewModel.avatarUrl {
            avatarImageView.kf.setImage(with: url)
        }

        ownerNameLabel.text = viewModel.ownerName
        secondaryLabel.text = viewModel.secondaryText
        tagList.removeAllTags()

        for file in viewModel.fileTypes {
            tagList.addTag(file)
        }
    }
}




import Anchorage
import Kingfisher
import UIKit

final class GistView: UIView {
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()

    private lazy var ownerNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .label
        return label
    }()

    private lazy var creationDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 12, weight: .light)
        label.textColor = .secondaryLabel
        return label
    }()

    private let containerView = UIView()

    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    private func setup() {
        containerView.backgroundColor = .systemGroupedBackground

        setupScrollView()
        setupAvatar()
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
        let stackView = StackViewBuilder {
            let stackView = StackViewBuilder {
                $0.spacing = 4
                $0.arrangedSubviews = [ownerNameLabel, creationDateLabel]
            }.build()

            $0.axis = .horizontal
            $0.spacing = 16
            $0.alignment = .center
            $0.arrangedSubviews = [avatarImageView, stackView]
        }.build()

        containerView.addSubview(stackView)

        stackView.horizontalAnchors == containerView.horizontalAnchors + 16
        stackView.topAnchor == containerView.topAnchor + 24
    }

    private func setupAvatar() {
        avatarImageView.heightAnchor == 60
        avatarImageView.widthAnchor == 60

        avatarImageView.layer.cornerRadius = 30
        avatarImageView.layer.masksToBounds = true
    }
}

extension GistView {
    struct ViewModel {
        let avatarUrl: URL?
        let ownerName: String
        let creationDate: String
    }

    func display(with viewModel: ViewModel) {
        if let url = viewModel.avatarUrl {
            avatarImageView.kf.setImage(with: url)
        }

        ownerNameLabel.text = viewModel.ownerName
        creationDateLabel.text = viewModel.creationDate
    }
}

import Anchorage
import UIKit

public final class ErrorStateView: BaseView {
    public typealias Action = (title: String, handler: () -> Void)

    private var handler: (() -> Void)?

    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .label
        return label
    }()

    private let messageLabel: UILabel = {
        let label = UILabel()
        label.font = .preferredFont(forTextStyle: .body)
        label.adjustsFontForContentSizeCategory = true
        label.textColor = .secondaryLabel
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    private lazy var actionButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(touchUpInsideActionButton), for: .touchUpInside)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.titleLabel?.adjustsFontForContentSizeCategory = true

//        button.layer.borderColor = UIColor.systemBlue.cgColor
//        button.layer.borderWidth = 1
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true

        return button
    }()

    private lazy var buttonWrapperView: UIView = {
        let view = UIView()
        view.addSubview(actionButton)
        return view
    }()

    override func setup() {
        addSubview(titleLabel)
        addSubview(messageLabel)
        addSubview(actionButton)

        titleLabel.centerAnchors == centerAnchors
        messageLabel.topAnchor == titleLabel.bottomAnchor + 16
        messageLabel.horizontalAnchors == horizontalAnchors + 20
        actionButton.topAnchor == messageLabel.bottomAnchor + 20
        actionButton.horizontalAnchors <= horizontalAnchors + 20

        actionButton.heightAnchor == 40
    }

    @objc private func touchUpInsideActionButton() {
        handler?()
    }
}

extension ErrorStateView {

    func show(title: String?, message: String? = nil, action: Action) {
        titleLabel.text = title
        messageLabel.text = message

        actionButton.setTitle(action.title, for: .normal)
        handler = action.handler
    }
}

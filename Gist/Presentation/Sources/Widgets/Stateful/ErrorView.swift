import Anchorage
import UIKit
import StatefulViewController

class ErrorView: BasicPlaceholderView {

    private let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .center
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
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .callout)
        button.titleLabel?.adjustsFontForContentSizeCategory = true
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 6
        button.layer.masksToBounds = true
        button.setTitle("Tap to reload", for: .normal)

        return button
    }()

    let tapGestureRecognizer = UITapGestureRecognizer()
	
	override func setupView() {
		super.setupView()
		
        backgroundColor = .systemBackground
		
		actionButton.addGestureRecognizer(tapGestureRecognizer)
        actionButton.heightAnchor == 40

        let stackView = StackViewBuilder {
            let stackView = StackViewBuilder {
                $0.spacing = 8
                $0.arrangedSubviews = [titleLabel, messageLabel]
            }.build()

            $0.spacing = 32
            $0.arrangedSubviews = [stackView, actionButton]
        }.build()

		centerView.addSubview(stackView)

        stackView.edgeAnchors == centerView.edgeAnchors
	}

}

extension ErrorView {
    func show(_ error: UserError, fromAnchor viewController: StatefulViewController) {
        titleLabel.text = error.title
        messageLabel.text = error.message
        viewController.endLoading(animated: true, error: error, completion: nil)
    }
}

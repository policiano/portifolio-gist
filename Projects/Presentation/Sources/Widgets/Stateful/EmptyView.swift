import Anchorage
import UIKit

class EmptyView: BasicPlaceholderView {
	
	let label = UILabel()

	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.white

        label.text = L10n.EmptyState.message
        label.numberOfLines = 0
        label.textAlignment = .center

		centerView.addSubview(label)

        label.edgeAnchors == centerView.edgeAnchors
	}
}

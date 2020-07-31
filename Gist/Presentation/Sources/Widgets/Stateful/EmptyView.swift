import Anchorage
import UIKit

class EmptyView: BasicPlaceholderView {
	
	let label = UILabel()

	override func setupView() {
		super.setupView()
		
		backgroundColor = UIColor.white

		label.text = "There is nothing to see so far."
        label.numberOfLines = 0
        label.textAlignment = .center

		centerView.addSubview(label)

        label.edgeAnchors == centerView.edgeAnchors
	}
}

import Anchorage
import UIKit

final class LoadingView: BasicPlaceholderView, StatefulPlaceholderView {

	let label = UILabel()
	
	override func setupView() {
		super.setupView()
		
        let activityIndicator = UIActivityIndicatorView(style: .large)
		activityIndicator.startAnimating()

		centerView.addSubview(activityIndicator)
        activityIndicator.edgeAnchors == centerView.edgeAnchors
	}

    func placeholderViewInsets() -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
}

import UIKit

protocol CustomViewController {
    associatedtype View: UIView
}

extension CustomViewController where Self: UIViewController {
    var customView: View {
        guard let customView = view as? View else {
            fatalError("Expected this view controller's view to be of type \(View.self) but got \(type(of: view))")
        }
        return customView
    }
}

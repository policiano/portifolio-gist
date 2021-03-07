import Foundation
import UIKit

public class StackViewBuilder {
    public var axis: NSLayoutConstraint.Axis = .vertical
    public var alignment: UIStackView.Alignment = .fill
    public var spacing: CGFloat = 0.0
    public var distribution: UIStackView.Distribution = .fillProportionally
    public var arrangedSubviews: [UIView] = []

    public typealias BuilderClosure = (StackViewBuilder) -> Void

    public init(buildClosure: BuilderClosure) {
        buildClosure(self)
    }

    public func build() -> UIStackView {
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.axis = axis
        stackView.alignment = alignment
        stackView.spacing = spacing
        stackView.distribution = distribution
        return stackView
    }
}

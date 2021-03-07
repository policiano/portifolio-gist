import UIKit

public class BaseView: UIView {
    init() {
        super.init(frame: .zero)
        setup()
    }

    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }

    func setup() { }
}

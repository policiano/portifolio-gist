import UIKit

public final class GistViewController: BaseViewController {

    public override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .random
        title = "Gist"
    }
}

extension UIColor {
    static var random: UIColor {
        return UIColor(red: .random(in: 0...1),
                       green: .random(in: 0...1),
                       blue: .random(in: 0...1),
                       alpha: 1.0)
    }
}

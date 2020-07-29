import UIKit

public final class GistViewController: BaseViewController, CustomViewController {
    typealias View = GistView

    public override func loadView() {
        view = GistView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()

        let headerViewModel = GistDigestView.ViewModel(
            avatarUrl: URL(string: "https://avatars2.githubusercontent.com/u/50024899?v=4"),
            ownerName: "emanuel-jose",
            secondaryText: "Created 18 minutes ago"
        )

        let viewModel = GistView.ViewModel(
            headerViewModel: headerViewModel,
            description: "My awesome gist",
            files: []
        )

        customView.display(with: viewModel)
    }
}

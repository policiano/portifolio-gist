import UIKit

public final class GistViewController: BaseViewController, CustomViewController {
    typealias View = GistView

    public override func loadView() {
        view = GistView()
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationItem.largeTitleDisplayMode = .never
        
        let files = [
            "application/json",
            "text/plain",
            "text/html",
            "image/jpeg",
            "image/png",
            "audio/mpeg",
            "audio/ogg",
            "video/mp4",
            "application/octet-stream"
        ]

        let headerViewModel = GistDigestView.ViewModel(
            avatarUrl: URL(string: "https://avatars2.githubusercontent.com/u/50024899?v=4"),
            ownerName: "emanuel-jose",
            secondaryText: "Created 18 minutes ago",
            fileTypes: files
        )

        let viewModel = GistView.ViewModel(
            headerViewModel: headerViewModel,
            description: "My awesome gist",
            files: files
        )

        customView.display(with: viewModel)
    }
}

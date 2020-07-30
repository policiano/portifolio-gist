import Foundation

enum Discover {
    enum GetDiscoveries {
        struct Request { }
        enum ViewModel {
            case content([GistDigestView.ViewModel])
            case failure(UserError)
        }
    }

    enum SelectGist {
        struct Request {
            let index: Int
        }

        typealias ViewModel = GistView.ViewModel
    }
}

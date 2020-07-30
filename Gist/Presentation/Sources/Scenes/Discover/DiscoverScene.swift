import Foundation

enum Discover {
    enum GetMoreDiscoveries {
        struct Request { }
        enum ViewModel {
            case content(
                list: [GistDigestView.ViewModel],
                hasMoreDataAvailable: Bool
            )
            case failure(UserError)

        }
    }

    enum SelectGist {
        struct Request {
            let index: Int
        }

        typealias ViewModel = GistDigest
    }
}

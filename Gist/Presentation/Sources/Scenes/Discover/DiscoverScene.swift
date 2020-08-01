import Foundation

enum Discover {
    enum GetDiscoveries {
        struct Request { }
        enum ViewModel {
            case content(
                list: [GistDigestCell.ViewModel],
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

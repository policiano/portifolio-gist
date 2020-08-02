import Foundation

enum Gists {
    enum GetGists {
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

    enum CheckUpdates {
        struct Request {
            let selectedGist: GistDigestCell.ViewModel?
        }

        struct ViewModel {
            let index: IndexPath
            let selectedGist: GistDigestCell.ViewModel
        }
    }

    enum Bookmark {
        struct Request {
            let index: IndexPath
            let gist: GistDigestCell.ViewModel
        }

        struct ViewModel {
            let index: IndexPath
            let bookmarkedGist: GistDigestCell.ViewModel
        }
    }
}

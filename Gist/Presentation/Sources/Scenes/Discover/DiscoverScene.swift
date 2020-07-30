import Foundation

enum Discover {
    enum GetDiscoveries {
        struct Request { }
        enum ViewModel {
            case content([GistDigestView.ViewModel])
            case failure
        }
    }
}

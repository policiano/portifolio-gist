import Foundation

public class GistDigest {
    public let id: String
    public let createdAt: String
    public let description: String?
    public let owner: Owner
    public let files: [File]
    public var isBookmarked: Bool

    public init(
        id: String,
        createdAt: String,
        description: String?,
        owner: Owner,
        files: [File],
        isBookmarked: Bool
    ) {
        self.id = id
        self.createdAt = createdAt
        self.description = description
        self.owner = owner
        self.files = files
        self.isBookmarked = isBookmarked
    }
}

extension GistDigest {
    public struct File {
        public let name: String
        public let type: String

        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }
}

extension GistDigest {
    public struct Owner {
        public let name: String
        public let avatarUrl: URL?

        public init(name: String, avatarUrl: URL?) {
            self.name = name
            self.avatarUrl = avatarUrl
        }
    }
}

import Foundation

public struct GistDigest {
    public let id: String
    public let description: String?
    public let owner: Owner
    public let files: [File]

    public init(
        id: String,
        description: String?,
        owner: Owner,
        files: [File]
    ) {
        self.id = id
        self.description = description
        self.owner = owner
        self.files = files
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

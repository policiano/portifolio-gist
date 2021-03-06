import Foundation

public class GistDigest: Codable {
    public let id: String
    public let createdAt: String
    public let description: String?
    public let owner: Owner
    public let files: [File]
    public var bookmarkedAt: Date?
    public let snippetPath: String

    public init(
        id: String,
        createdAt: String,
        description: String?,
        owner: Owner,
        files: [File],
        bookmarkedAt: Date?,
        snippetPath: String
    ) {
        self.id = id
        self.createdAt = createdAt
        self.description = description
        self.owner = owner
        self.files = files
        self.bookmarkedAt = bookmarkedAt
        self.snippetPath = snippetPath
    }
}

extension GistDigest {
    var isBookmarked: Bool {
        get {
            bookmarkedAt != nil
        }

        set {
            bookmarkedAt = newValue == true ? Date() : nil
        }
    }
}

extension GistDigest {
    public struct File: Codable {
        public let name: String
        public let type: String

        public init(name: String, type: String) {
            self.name = name
            self.type = type
        }
    }
}

extension GistDigest {
    public struct Owner: Codable {
        public let name: String
        public let avatarUrl: URL?

        public init(name: String, avatarUrl: URL?) {
            self.name = name
            self.avatarUrl = avatarUrl
        }
    }
}

import Foundation
@testable import Gist

extension GistDigest.File {
    public static func fixture(
        name: String = .anyValue,
        type: String = .anyValue
    ) -> Self {
        .init(name: name, type: type)
    }
}

extension GistDigest.Owner {
    public static func fixture(
        name: String = .anyValue,
        avatarUrl: URL? = .anyValue
    ) -> Self {
        .init(name: name, avatarUrl: avatarUrl)
    }
}

extension GistDigest {
    public static func fixture(
        id: String = .anyValue,
        createdAt: String = .anyValue,
        description: String? = .anyValue,
        owner: Owner = .fixture(),
        files: [File] = [],
        bookmarkedAt: Date? = nil
    ) -> GistDigest {
        .init(
            id: id,
            createdAt: createdAt,
            description: description,
            owner: owner,
            files: files,
            bookmarkedAt: bookmarkedAt
        )
    }
}

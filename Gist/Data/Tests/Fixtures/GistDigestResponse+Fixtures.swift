@testable
import Gist
import Foundation

extension GistDigestResponse {
    static func fixture(
        id: String? = .anyValue,
        description: String? = .anyValue,
        owner: Owner? = .anyValue,
        files: [String: File] = [:]
    ) -> Self {
        .init(
            id: id,
            description: description,
            owner: owner,
            files: files
        )
    }
}

extension GistDigestResponse.File {
    static func fixture(
        filename: String? = .anyValue,
        type: String? = .anyValue
    ) -> Self {
        .init(
            filename: filename,
            type: type
        )
    }
}

extension GistDigestResponse.Owner {
    static func fixture(
        login: String? = .anyValue,
        avatarUrl: String? = .anyValue
    ) -> Self {
        .init(
            login: login,
            avatarUrl: avatarUrl
        )
    }
}

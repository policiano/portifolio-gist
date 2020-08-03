@testable
import Gist
import Foundation

extension GistDigestCell.ViewModel {
    static func fixture(
        id: String = .anyValue,
        avatarUrl: URL? = .anyValue,
        ownerName: String = .anyValue,
        secondaryText: String? = .anyValue,
        fileTypes: [String] = [],
        isBookmarked: Bool = .anyValue
    ) -> Self {
        .init(
            id: id,
            avatarUrl: avatarUrl,
            ownerName: ownerName,
            secondaryText: secondaryText,
            fileTags: fileTypes,
            isBookmarked: isBookmarked
        )
    }
}

import Foundation
@testable import Presentation

extension GistDigestCell.ViewModel {
    public static func fixture(
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

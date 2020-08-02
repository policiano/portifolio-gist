@testable
import Gist
import Foundation

extension GistDigestCell.ViewModel {
    static func fixture(
        avatarUrl: URL? = .anyValue,
        ownerName: String = .anyValue,
        secondaryText: String? = .anyValue,
        fileTypes: [String] = []
    ) -> Self {
        .init(
            avatarUrl: avatarUrl,
            ownerName: ownerName,
            secondaryText: secondaryText,
            fileTypes: fileTypes
        )
    }
}

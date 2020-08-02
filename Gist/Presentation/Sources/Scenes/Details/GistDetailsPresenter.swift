import Foundation

protocol GistPresentationLogic {
    func getDetails(request: GistDetails.GetDetails.Request)
    func bookmark(request: GistDetails.Bookmark.Request)
}

final class GistDetailsPresenter: NSObject {
    private var gist: GistDigest
    private let bookmarkGist: BookmarkGistUseCase
    weak var display: GistDetailsDisplayLogic?

    init(gist: GistDigest, bookmarkGist: BookmarkGistUseCase) {
        self.gist = gist
        self.bookmarkGist = bookmarkGist
    }

    private func map(gist: GistDigest) -> GistDetails.GetDetails.ViewModel {
        let fileTags = gist.fileTags()

        let header = GistDetailsTableViewController.HeaderViewModel(
            id: gist.id,
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: gist.formmatedCreationDate,
            fileTags: fileTags,
            isBookmarked: gist.isBookmarked
        )

        typealias Section = GistDetailsTableViewController.Section
        var sections: [Section] = [.init(descriptor: .header, rows: [.init(title: "")])]

        if let description = gist.formmatedDescription {
            let section = Section(descriptor: .description, rows: [.init(title: description)])
            sections.append(section)
        }

        let files = gist.files.map { Section.Row(title: $0.name) }

        if files.isEmpty == false {
            let section = Section(descriptor: .files, rows: files)
            sections.append(section)
        }

        return .content(header: header, sections: sections)
    }

    private func mapAndDisplay(_ gist: GistDigest) {
        let viewModel = self.map(gist: gist)
        self.display?.displayBookmark(viewModel: viewModel)
    }
}

extension GistDetailsPresenter: GistPresentationLogic {
    func getDetails(request: GistDetails.GetDetails.Request) {
        let viewModel = map(gist: gist)
        display?.displayDetails(viewModel: viewModel)
    }

    func bookmark(request: GistDetails.Bookmark.Request) {
        bookmarkGist.execute(gist: gist, weakfy { (strongSelf, result) in
            guard let updatedGist = result.value else {
                return
            }
            self.gist = updatedGist
            self.mapAndDisplay(updatedGist)
        })
    }
}

extension GistDigest {
    var formmatedCreationDate: String {
        let dateFormatter = DateFormatter()

        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        guard let date = dateFormatter.date(from: createdAt) else {
            return ""
        }
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        guard let stringDate = dateFormatter.string(from: date).valueOrNil else {
            return ""
        }

        return L10n.GistDetails.creationDate(stringDate)
    }
}

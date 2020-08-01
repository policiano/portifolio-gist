import Foundation

protocol GistPresentationLogic {
    func getDetails(request: Gist.GetDetails.Request)
    func bookmark(request: Gist.Bookmark.Request)
}

final class GistPresenter {
    private let gist: GistDigest
    private let bookmarkGist: BookmarkGistUseCase
    weak var display: GistDisplayLogic?

    init(gist: GistDigest, bookmarkGist: BookmarkGistUseCase) {
        self.gist = gist
        self.bookmarkGist = bookmarkGist
    }

    private func map(gist: GistDigest) -> Gist.GetDetails.ViewModel {
        let fileTags = gist.fileTags()

        let header = GistTableViewController.HeaderViewModel(
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: gist.formmatedCreationDate,
            fileTags: fileTags
        )

        typealias Section = GistTableViewController.Section
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
}

extension GistPresenter: GistPresentationLogic {
    func getDetails(request: Gist.GetDetails.Request) {
        let viewModel = map(gist: gist)
        display?.displayDetails(viewModel: viewModel)
    }

    func bookmark(request: Gist.Bookmark.Request) {
        bookmarkGist.execute(gist: gist) { [weak self] in
            guard case .success(let updatedGist) = $0, let self = self else {
                return
            }
            let viewModel = self.map(gist: updatedGist)
            self.display?.displayBookmark(viewModel: viewModel)
        }
    }
}

extension GistDigest {
    var formmatedCreationDate: String {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        dateFormatter.calendar = Calendar(identifier: .gregorian)

        guard let date = dateFormatter.date(from: createdAt) else {
            return ""
        }
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short
        let stringDate = dateFormatter.string(from: date)
        if stringDate.isEmpty {
            return ""
        }

        return "Created on \(stringDate)"
    }
}

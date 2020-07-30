import Foundation

protocol GistPresentationLogic {
    func getDetails(request: Gist.GetDetails.Request)
}

final class GistPresenter {
    private let gist: GistDigest
    weak var display: GistDisplayLogic?

    init(gist: GistDigest) {
        self.gist = gist
    }

    private func map(gist: GistDigest) -> Gist.GetDetails.ViewModel {
        let fileTags = gist.fileTags()

        let header = GistTableViewController.HeaderViewModel(
            avatarUrl: gist.owner.avatarUrl,
            ownerName: gist.owner.name,
            secondaryText: "some date",
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
}

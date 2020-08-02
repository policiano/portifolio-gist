import UIKit


final class BookmarksConfigurator {

    func resolve() -> UIViewController {
        let bookmarkRepository = FirebaseBookmarksRepository()
        let gistsRepository = MoyaGistsRepository(bookmarksRepository: bookmarkRepository)
        let getPublicGists = GetPublicGists(
            repository: gistsRepository
        )

        let bookmarkGist = BookmarkGist(repository: bookmarkRepository)
        let getAllBookmarks = GetAllBookmarks(repository: bookmarkRepository)

        let presenter = BookmarksPresenter(
            getAllBookmarks: getAllBookmarks,
            getPublicGists: getPublicGists,
            bookmarkGist: bookmarkGist
        )

        let router = GistsRouter(dataStore: presenter)
        let viewController = BookmarksViewController(presenter: presenter, router: router)

        presenter.display = viewController
        router.viewController = viewController

        return viewController
    }
}

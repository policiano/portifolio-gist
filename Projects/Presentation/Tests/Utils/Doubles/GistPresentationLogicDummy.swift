@testable import Presentation

public final class GistPresentationLogicDummy: GistPresentationLogic {
    public init() { }

    public func getDetails(request: GistDetails.GetDetails.Request) { }

    public func bookmark(request: GistDetails.Bookmark.Request) { }
}

@testable import Presentation

public final class GistsPresenterTestsSpy: GistsRoutingLogic {
    public init() { }
    
    public private(set) var routeToDigestCalled = false
    public private(set) var routeToDigestViewModelPassed: GistDigestCell.ViewModel?
    public func routeToDigest(_ gist: GistDigestCell.ViewModel) {
        routeToDigestCalled = true
        routeToDigestViewModelPassed = gist
    }

    public func routeToBookmarks() {

    }
}

@testable
import Gist

final class DiscoverPresentationLogicSpy: DiscoverPresentationLogic {
    private(set) var getDiscoveriesCalled = false
    func getDiscoveries(request: Discover.GetDiscoveries.Request) {
        getDiscoveriesCalled = true
    }
}

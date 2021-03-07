import Domain
import Utils

public final class GistsRepositorySpy: GistsRepository {
    public init() { }

    public private(set) var getPublicGistsCalled = false
    public private(set) var getPublicGistsPagePassed: Int?
    public var getPublicGistsResultToBeReturned: Result<[GistDigest]>?

    public func getPublicGists(page: Int, completion: @escaping (Result<[GistDigest]>) -> Void) {
        getPublicGistsCalled = true
        getPublicGistsPagePassed = page
        if let result = getPublicGistsResultToBeReturned {
            completion(result)
        }
    }
}

@testable import Gist

public final class GistsRepositorySpy: GistsRepository {
    public init() { }

    public private(set) var getPublicGistsCalled = false
    public var getPublicGistsResultToBeReturned: Result<[GistDigest]>?

    public func getPublicGists(completion: @escaping (Result<[GistDigest]>) -> Void) {
        getPublicGistsCalled = true
        if let result = getPublicGistsResultToBeReturned {
            completion(result)
        }
    }
}

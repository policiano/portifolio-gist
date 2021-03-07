import Domain
import Utils

public final class GetPublicGistsUseCaseSpy: GetPublicGistsUseCase {
    public init() { }

    public private(set) var executeCalled = false
    public var executeResultToBeReturned: Result<[GistDigest]>?
    public func execute(completion: @escaping (Result<[GistDigest]>) -> Void) {
        executeCalled = true
        if let result = executeResultToBeReturned {
            completion(result)
        }
    }
}

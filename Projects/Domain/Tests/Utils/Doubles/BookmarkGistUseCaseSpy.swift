import Domain

public final class BookmarkGistUseCaseSpy: BookmarkGistUseCase {
    public init() { }

    public private(set) var executeCalled = false
    public private(set) var executeGistPassed: GistDigest?
    public var executeResultToBeReturned: Result<GistDigest, Never>?
    
    public func execute(gist: GistDigest, _ completion: @escaping (Result<GistDigest, Never>) -> Void) {
        executeCalled = true
        executeGistPassed = gist
        if let result = executeResultToBeReturned {
            completion(result)
        }
    }
}

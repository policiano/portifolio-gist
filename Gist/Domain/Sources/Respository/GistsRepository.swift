import Foundation

public protocol GistsRepository {
    func getPublicGists(completion: @escaping (Result<[GistDigest]>) -> Void)
}

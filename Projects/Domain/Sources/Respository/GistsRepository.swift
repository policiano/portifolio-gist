import Utils

public protocol GistsRepository {
    func getPublicGists(page: Int, completion: @escaping (Result<[GistDigest]>) -> Void)
}

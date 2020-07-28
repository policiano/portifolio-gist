import Foundation
import Moya

public class GistsTargetType: TargetType {
    public var baseURL: URL {
        URL(string: "https://api.github.com/gists/")!
    }

    public var headers: [String: String]? {
        ["Accept": "application/vnd.github.v3+json"]
    }

    public var path: String { "" }

    public var method: Moya.Method { .get }

    public var sampleData: Data { Data() }

    public var task: Task { .requestPlain }

    public var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}

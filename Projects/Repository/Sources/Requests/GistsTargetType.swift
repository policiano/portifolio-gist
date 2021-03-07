import Foundation
import Moya
import Utils

public class GistsTargetType: TargetType {
    public var baseURL: URL {
        URL(string: "\(URLs.baseUrl)/gists")!
    }

    public var headers: [String: String]? {
        [
//            "Authorization": "token b67cab50ee9562b51e0be17fa2c3b3d6899bdf18",
            "Accept": "application/vnd.github.v3+json"
        ]
    }

    public var path: String { "" }

    public var method: Moya.Method { .get }

    public var sampleData: Data { Data() }

    public var task: Task { .requestPlain }

    public var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}

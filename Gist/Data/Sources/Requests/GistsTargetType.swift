import Foundation
import Moya

class GistsTargetType: TargetType {
    var baseURL: URL {
        URL(string: "https://api.github.com/gists/")!
    }

    var headers: [String: String]? {
        ["Accept": "application/vnd.github.v3+json"]
    }

    var path: String { "" }

    var method: Moya.Method { .get }

    var sampleData: Data { Data() }

    var task: Task { .requestPlain }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}

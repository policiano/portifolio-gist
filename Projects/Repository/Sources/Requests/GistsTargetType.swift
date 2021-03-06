import Foundation
import Moya
import Utils

public class GistsTargetType: TargetType {
    public var baseURL: URL {
        URL(string: "\(URLs.baseUrl)/gists")!
    }

    public var headers: [String: String]? {
        [
            "Authorization": "token 981ed952c9d4d69adb35206877ef43c500f098f4",
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

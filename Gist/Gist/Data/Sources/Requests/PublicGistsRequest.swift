import Foundation
import Moya

public final class PublicGistsRequest: GistsTargetType {
    public let page: Int

    public init(page: Int) {
        self.page = page
    }

    public override var path: String {
        "public"
    }

    public override var task: Task {
        let parameters: [String: Any] = [
            "page": page,
            "per_page": 20
        ]
        return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
    }
}

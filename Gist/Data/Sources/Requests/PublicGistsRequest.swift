import Foundation
import Moya

public final class PublicGistsRequest: GistsTargetType {
    private let page: Int

    public init(page: Int) {
        self.page = page
    }

    public override var path: String {
        "public"
    }

    public override var task: Task {
        .requestParameters(parameters: ["page": page], encoding: URLEncoding.queryString)
    }
}

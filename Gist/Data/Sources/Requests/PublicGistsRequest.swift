import Foundation
import Moya

public final class PublicGistsRequest: GistsTargetType {
    private let currentPage: Int

    public init(currentPage: Int) {
        self.currentPage = currentPage
    }

    public override var path: String {
        "public"
    }

    public override var task: Task {
        .requestParameters(parameters: ["page": currentPage], encoding: URLEncoding.queryString)
    }
}

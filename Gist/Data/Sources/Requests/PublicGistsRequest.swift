import Foundation
import Moya

final class PublicGistsRequest: GistsTargetType {
    private let currentPage: Int

    init(currentPage: Int) {
        self.currentPage = currentPage
    }

    override var path: String {
        "public"
    }

    override var task: Task {
        .requestParameters(parameters: ["page": currentPage], encoding: URLEncoding.queryString)
    }
}

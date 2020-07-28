import Foundation
import Moya

@testable import Gist

public class MoyaDataSourceSpy<Request: TargetType>: MoyaDataSource<Request> {
    public typealias Target = Any

    public private(set) var requestCalled = false
    public private(set) var targetPassed: Request?
    public var requestResultToBeReturned: Any?
    public override func request<T>(_ target: Request, completion: @escaping (Result<T>) -> Void) where T : Decodable, T : Encodable {
        targetPassed = target
        requestCalled = true

        if let result = requestResultToBeReturned as? Result<T> {
            completion(result)
        }
    }
}

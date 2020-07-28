import Foundation
import Moya

@testable import Gist

public final class MoyaDataSourcingSpy: MoyaDataSourcing {
    public typealias Target = Any

    public private(set) var requestCalled = false
    public var requestResultToBeReturned: Any?
    public func request<T>(_ target: Target, completion: @escaping (Result<T>) -> Void) where T : Decodable, T : Encodable {
        requestCalled = true

        if let result = requestResultToBeReturned as? Result<T> {
            completion(result)
        }
    }
}

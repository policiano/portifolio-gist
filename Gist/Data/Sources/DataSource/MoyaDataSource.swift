import Foundation
import Moya

public protocol MoyaDataSourcing {
    associatedtype Target
    func request<T: Codable>(_ target: Target, completion: @escaping (Result<T>) -> Void)
}

public final class MoyaDataSource<TargetType: Moya.TargetType>: MoyaProvider<TargetType>, MoyaDataSourcing {
    public typealias Target = TargetType
    private var cancellable: Cancellable?

    public init() { }

    public func request<T>(_ target: TargetType, completion: @escaping (Result<T>) -> Void) where T : Decodable, T : Encodable {
        cancellable?.cancel()
        
        cancellable = request(target, callbackQueue: .global(), progress: nil) { response in
            switch response {
            case .success(let response):
                do {
                    let successResponse = try response.filterSuccessfulStatusCodes()
                    let data = try successResponse.map(T.self)
                    completion(.success(data))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}


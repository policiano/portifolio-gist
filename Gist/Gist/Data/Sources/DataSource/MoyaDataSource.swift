import Foundation
import Moya

public class MoyaDataSource<Target: TargetType> {
    private var cancellable: Cancellable?
    private let provider: MoyaProvider<Target>

    public init(provider: MoyaProvider<Target> = .init()) {
        self.provider = provider
    }

    public func request<T>(_ target: Target, completion: @escaping (Result<T>) -> Void) where T : Decodable, T : Encodable {
        cancellable?.cancel()
        
        cancellable = provider.request(target) { response in
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


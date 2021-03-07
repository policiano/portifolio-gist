import Foundation
import Moya

struct ErrorHandler {
    static func userError(from error: Error? = nil) -> UserError {
        var title: String = L10n.Error.Generic.title
        var message: String = L10n.Error.Generic.message

        guard let error = error else {
            title = L10n.Error.Empty.title
            message = L10n.Error.Empty.message

            return .init(title: title, message: message)
        }

        if case .underlying = (error as? MoyaError) {
            title = L10n.Error.Connection.title
            message = L10n.Error.Connection.message

            return .init(title: title, message: message)
        }

        return .init(title: title, message: message)
    }

    private static var connectionErrorCodes: [Int] {
        let codes: [URLError.Code] = [
            .notConnectedToInternet,
            .networkConnectionLost,
            .cannotLoadFromNetwork,
            .timedOut
        ]
        return codes.map { $0.rawValue }
    }
}

struct UserError: Error {
    let title: String
    let message: String
}


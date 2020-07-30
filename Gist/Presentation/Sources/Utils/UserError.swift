import Foundation
import Moya

struct ErrorHandler {
    static func userError(from error: Error? = nil) -> UserError {
        var title: String = "Ops! Something went wrong"
        var message: String = "Looks like we are having some internal errors. Try again later"

        guard let error = error else {
            title = "Nothing found"
            message = "There is no Gist to show you so far."

            return .init(title: title, message: message)
        }

        if case .underlying = (error as? MoyaError) {
            title = "No internet connection"
            message = "Check your connection and try again."

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


import Foundation
import Utils

public struct ErrorDummy: Error, Identifiable, Equatable {
    public let id = UUID()
    public var localizedDescription: String = .anyValue

    public init() { }
}

public extension Error {
    var asErrorDummy: ErrorDummy? {
        self as? ErrorDummy
    }
}

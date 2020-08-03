import Foundation

public struct ErrorDummy: Error, Identifiable, Equatable {
    public let id = UUID()
    public var localizedDescription: String = .anyValue

    public init() { }
}

extension Error {
    var asErrorDummy: ErrorDummy? {
        return self as? ErrorDummy
    }
}

import XCTest
import Combine

class Test: XCTestCase {
    func test_() {

    }
}

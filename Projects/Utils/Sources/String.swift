import Foundation

extension String {
    public var valueOrNil: String? {
        if self.isEmpty {
            return nil
        }
        return self
    }
}

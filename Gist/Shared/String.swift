import Foundation

extension String {
    var valueOrNil: String? {
        if self.isEmpty {
            return nil
        }
        return self
    }
}

import Foundation

protocol Weakfiable: AnyObject { }

extension NSObject: Weakfiable { }

extension Weakfiable {
    func weakfy(_ code: @escaping (Self) -> Void) -> () -> Void {
        return { [weak self] in
            guard let self = self else { return }

            code(self)
        }
    }

    func weakfy<T>(_ code: @escaping (Self, T) -> Void) -> (T) -> Void {
        return { [weak self] arg in
            guard let self = self else { return }

            code(self, arg)
        }
    }
}

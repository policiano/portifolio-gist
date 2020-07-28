import Foundation

public protocol Random {
    static var anyValue: Self { get }
}

extension Optional: Random where Wrapped: Random{
    public static var anyValue: Optional<Wrapped> {
        let optional = Optional<Wrapped>(.anyValue)
        return Bool.random() ? optional : nil
    }
}

extension Double: Random {
    public static var anyValue: Self {
        Double.random(in: -10 ..< 10)
    }
}

extension Int: Random {
    public static var anyValue: Self {
        Int.random(in: -100_000 ..< 100_000)
    }
}

extension String: Random {
    public static var anyValue: String {
        let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<20).map{ _ in letters.randomElement()! })
    }
}

extension URL: Random {
    public static var anyValue: URL {
        URL(fileURLWithPath: .anyValue)
    }
}

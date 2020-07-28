import Foundation

// Functor

infix operator <^>: AdditionPrecedence

func <^><T, U>(f: (T) -> U, a: T?) -> U? {
    return a.map(f)
}

// Applicative

infix operator <*>: AdditionPrecedence

func <*><A, B>(f: ((A) -> B)?, a: A?) -> B? {
    switch f {
    case .some(let fx): return fx <^> a
    case .none: return .none
    }
}

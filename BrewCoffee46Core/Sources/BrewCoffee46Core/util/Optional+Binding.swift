import SwiftUI

public func ?? <T: Sendable>(lhs: Binding<T?>, rhs: T) -> Binding<T> {
    Binding(
        get: { lhs.wrappedValue ?? rhs },
        set: { lhs.wrappedValue = .some($0) }
    )
}

public func ?? (lhs: Binding<String?>, rhs: String) -> Binding<String> {
    Binding(
        get: {
            if let value = lhs.wrappedValue, !value.isEmpty {
                return value
            } else {
                return rhs
            }
        },
        set: { lhs.wrappedValue = .some($0) }
    )
}

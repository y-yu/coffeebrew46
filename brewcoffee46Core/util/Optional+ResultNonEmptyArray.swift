extension Optional {
    internal func toResultNea<E: Error>(_ error: E) -> ResultNea<Wrapped, E> {
        switch self {
        case .none:
            return .failure(NonEmptyArray(error))
        case .some(let value):
            return .success(value)
        }
    }

    internal func toArray() -> [Wrapped] {
        switch self {
        case .none:
            return []
        case .some(let value):
            return [value]
        }
    }

    internal func isDefined() -> Bool {
        switch self {
        case .none:
            return false
        case .some:
            return true
        }
    }

    internal func isEmpty() -> Bool {
        !isDefined()
    }
}

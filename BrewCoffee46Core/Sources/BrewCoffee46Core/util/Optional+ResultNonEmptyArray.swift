extension Optional {
    public func toResultNea<E: Error>(_ error: E) -> ResultNea<Wrapped, E> {
        switch self {
        case .none:
            return .failure(NonEmptyArray(error))
        case .some(let value):
            return .success(value)
        }
    }

    public func toArray() -> [Wrapped] {
        switch self {
        case .none:
            return []
        case .some(let value):
            return [value]
        }
    }

    public func isDefined() -> Bool {
        switch self {
        case .none:
            return false
        case .some:
            return true
        }
    }

    public func isEmpty() -> Bool {
        !isDefined()
    }
}

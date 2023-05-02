extension Optional {
    internal func toResultNel<E: Error>(_ error: E) -> ResultNel<Wrapped, E> {
        switch self {
        case .none:
            return .failure(NonEmptyList(error))
        case .some(let value):
            return .success(value)
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

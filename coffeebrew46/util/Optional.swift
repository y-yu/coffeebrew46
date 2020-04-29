extension Optional {
    internal func toResultNel<E: Error>(_ error: E) -> ResultNel<Wrapped, E> {
        switch self {
        case .none:
            return .failure(NonEmptyList(error))
        case .some(let value):
            return .success(value)
        }
    }
}

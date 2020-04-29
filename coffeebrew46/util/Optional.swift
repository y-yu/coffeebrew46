extension Optional {
    internal func toResult<E: Error>(_ error: E) -> Result<Wrapped, E> {
        switch self {
        case .none:
            return .failure(error)
        case .some(let value):
            return .success(value)
        }
    }
}

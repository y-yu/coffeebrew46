extension Optional {
    internal func toEither<E>(_ error: E) -> Either<E, Wrapped> {
        switch self {
        case .none:
            return .Left(error)
        case .some(let value):
            return .Right(value)
        }
    }
}

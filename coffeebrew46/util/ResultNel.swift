/**
 # A `Result` uses `NonEmptyList<Failure>` as errors.
 */
public typealias ResultNel<Success, Failure: Error> =
    Result<Success, NonEmptyList<Failure>>

infix operator |+|: AssociativityRight

public func |+|<A, B, E: Error>(
    r1: ResultNel<A, E>,
    r2: ResultNel<B, E>
) -> ResultNel<(A, B), E> {
    switch (r1, r2) {
    case (.success(let a), .success(let b)):
        return .success((a, b))
    case (.success(_), .failure(let eb)):
        return .failure(eb)
    case (.failure(let ea), .success(_)):
        return .failure(ea)
    case (.failure(let ea), .failure(let eb)):
        return .failure(ea ++ eb)
    }
}

// It is required to use `NonEmptyList` for `Failure` type parameter of `Result`
extension NonEmptyList: Error where A: Error { }

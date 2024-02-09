/// # A `Result` uses `NonEmptyArray<Failure>` as errors.
public typealias ResultNea<Success, Failure: Error> =
    Result<Success, NonEmptyArray<Failure>>

infix operator |+| : AssociativityRight

public func |+| <A, B, E: Error>(
    r1: ResultNea<A, E>,
    r2: ResultNea<B, E>
) -> ResultNea<(A, B), E> {
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

// It is required to use `NonEmptyArray` for `Failure` type parameter of `Result`
extension NonEmptyArray: Error where A: Error {}

extension ResultNea {
    func forEach(_ f: (Success) -> Void) -> Void {
        switch self {
        case .success(let result):
            f(result)
        case .failure(_):
            return
        }
    }
}

extension Result {
    func isSuccess() -> Bool {
        return switch self {
        case .success(_): true
        case .failure(_): false
        }
    }

    func isFailure() -> Bool {
        return !isSuccess()
    }
}

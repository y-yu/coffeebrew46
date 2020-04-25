enum Either<E, A>{
    case Left(E)
    case Right(A)
}

extension Either {
    func map<B>(_ f: (A) -> B) -> Either<E, B> {
        switch self {
        case .Left(let leftValue):
            return .Left(leftValue)
        case .Right(let rightValue):
            return .Right(f(rightValue))
        }
    }
    
    func fold<B>(ifLeft: (E) -> B, ifRight: (A) -> B) -> B {
        switch self {
        case .Left(let leftValue):
            return ifLeft(leftValue)
        case .Right(let rightValue):
            return ifRight(rightValue)
        }
    }
    
    func getOrElse(_ orElse: A) -> A {
        switch self {
        case .Left(_):
            return orElse
        case .Right(let rightValue):
            return rightValue
        }
    }
}

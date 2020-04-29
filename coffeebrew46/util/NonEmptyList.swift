/**
 # Immutable list.
 */
public enum ImmutableList<A> {
    case Nil
    indirect case Cons(A, ImmutableList<A>)
    
    func append(_ l: ImmutableList<A>) -> ImmutableList<A> {
        switch self {
        case .Cons(let h, let t):
            return .Cons(h, t.append(l))
        case .Nil:
            return l
        }
    }
    
    func toArray() -> Array<A> {
        switch self {
        case .Nil:
            return []
        case .Cons(let h, let t):
            var arr = t.toArray()
            arr.insert(h, at: 0)
            return arr
        }
    }
}

/**
 # Immutable list which size must be grater than 0.
 */
public struct NonEmptyList<A> {
    let head: A
    let tail: ImmutableList<A>
    
    func toArray() -> Array<A> {
        var arr = tail.toArray()
        arr.insert(head, at: 0)
        
        return arr
    }
}

extension NonEmptyList {
    init(_ a: A) {
        self.head = a
        self.tail = .Nil
    }
}

// Append operator.
infix operator ++: AssociativityRight

func ++<A>(_ nel1: NonEmptyList<A>, _ nel2: NonEmptyList<A>) -> NonEmptyList<A> {
    return NonEmptyList(
        head: nel1.head,
        tail: nel1.tail.append(.Cons(nel2.head, nel2.tail))
    )
}

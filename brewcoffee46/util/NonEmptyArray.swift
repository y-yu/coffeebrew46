/**
 # Immutable list.
 */
/*
public enum ImmutableList<A> {
    case Nil
    indirect case Cons(A, ImmutableList<A>)
}

extension ImmutableList {
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

    static func fromArray(_ array: [A]) -> ImmutableList<A> {
        var result: ImmutableList<A> = .Nil
        for e in array {
            result = .Cons(e, result)
        }
        return result
    }
}

extension ImmutableList: Equatable where A: Equatable {
    static public func ==(lhs: ImmutableList<A>, rhs: ImmutableList<A>) -> Bool {
        switch (lhs, rhs) {
        case (.Nil, .Nil):
            return true
        case (.Cons(let lh, let lt), .Cons(let rh, let rt)) :
            return lh == rh && lt == rt
        default:
            return false
        }
    }
}
 */

/// # Array which size must be grater than 0.
public struct NonEmptyArray<A> {
    let head: A
    let tail: [A]
}

extension NonEmptyArray: Equatable where A: Equatable {
    static public func == (lhs: NonEmptyArray<A>, rhs: NonEmptyArray<A>) -> Bool {
        return lhs.head == rhs.head && lhs.tail == rhs.tail
    }
}

extension NonEmptyArray {
    init(_ a: A) {
        self.head = a
        self.tail = []
    }

    init(_ h: A, _ t: [A]) {
        self.head = h
        self.tail = t
    }

    func count() -> Int {
        return tail.count + 1
    }

    func toArray() -> [A] {
        var arr: [A] = tail
        arr.insert(head, at: 0)
        return arr
    }
}

// Append operator.
infix operator ++ : AssociativityLeft

func ++ <A>(_ nel1: NonEmptyArray<A>, _ nel2: NonEmptyArray<A>) -> NonEmptyArray<A> {
    var arr: [A] = nel1.tail
    arr.append(nel2.head)
    arr += nel2.tail

    return NonEmptyArray(
        head: nel1.head,
        tail: arr
    )
}

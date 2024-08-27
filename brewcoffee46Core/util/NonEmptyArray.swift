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

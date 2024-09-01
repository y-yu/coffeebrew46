/// # Array which size must be grater than 0.
public struct NonEmptyArray<A> {
    public let head: A
    private(set) public var tail: [A]

    public mutating func append(_ a: A) {
        tail.append(a)
    }
}

extension NonEmptyArray: Equatable where A: Equatable {
    public static func == (lhs: NonEmptyArray<A>, rhs: NonEmptyArray<A>) -> Bool {
        return lhs.head == rhs.head && lhs.tail == rhs.tail
    }
}

extension NonEmptyArray {
    public init(_ a: A) {
        self.head = a
        self.tail = []
    }

    public init(_ h: A, _ t: [A]) {
        self.head = h
        self.tail = t
    }

    public func count() -> Int {
        return tail.count + 1
    }

    public func toArray() -> [A] {
        var arr: [A] = tail
        arr.insert(head, at: 0)
        return arr
    }
}

extension NonEmptyArray where A == CoffeeError {
    public func getAllErrorMessage() -> String {
        self.toArray().map { $0.getMessage() }.joined(separator: "\n")
    }
}

// Append operator.
infix operator ++ : AssociativityLeft

public func ++ <A>(_ nel1: NonEmptyArray<A>, _ nel2: NonEmptyArray<A>) -> NonEmptyArray<A> {
    var arr: [A] = nel1.tail
    arr.append(nel2.head)
    arr += nel2.tail

    return NonEmptyArray(
        head: nel1.head,
        tail: arr
    )
}

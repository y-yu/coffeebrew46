import SwiftUI

/**
 # A type of `Coproduct` which can be behave as `View`.
 */
protocol CoproductView: View {}

struct CNil<E: View>: CoproductView {
    var body: E
    
    init (_ body: E) {
        self.body = body
    }
}

/**
 # A Container which has some `View`s heterogeneously.
 */
enum CCons<H: View, T: CoproductViewTraverse>: CoproductView {
    struct Inl: CoproductView {
        let head: H
        
        init(_ head: H) {
            self.head = head
        }
    }
    
    struct Inr: CoproductView {
        let tail: T
        
        init(_ tail: T) {
            self.tail = tail
        }
    }
    
    case inl(Inl)
    case inr(Inr)
    
    func getInl() throws -> H {
        switch self {
        case .inl(let left):
            return left.head
        default:
            fatalError()
        }
    }
}

// Custom constructors.
extension CCons {
    static func apply<H: View, T: CoproductView>(_ head: H) -> CCons<H, T> {
        return CCons<H, T>.inl(CCons<H, T>.Inl(head))
    }
    
    static func apply<H: View, T: CoproductView>(_ tail: T) -> CCons<H, T> {
        return CCons<H, T>.inr(CCons<H, T>.Inr(tail))
    }
}

extension CCons: View where T: CoproductViewTraverse {
    var body: AnyView {
        switch self {
        case .inl(let left):
            return AnyView(left.traverse())
        case .inr(let right):
            return AnyView(right.traverse())
        }
    }
}

extension CCons.Inl: View {
    typealias Body = H
    
    var body: H {
        get {
            return self.traverse()
        }
    }
}

extension CCons.Inr: View where T: CoproductViewTraverse {
    typealias Body = CCons.Inr.Out
    
    var body: CCons.Inr.Out {
        get {
            return self.traverse()
        }
    }
}

import SwiftUI

/**
 # A protocol which reperesents that a type can pick up `View` value.
 */
protocol CoproductViewTraverse {
    associatedtype Out: View
 
    func traverse() -> Out
}

extension CNil: CoproductViewTraverse {
    typealias Out = E
    
    func traverse() -> E {
        return value
    }
}

extension CCons.Inl: CoproductViewTraverse {
    typealias Out = H
    
    func traverse() -> H {
        return head
    }
}

extension CCons.Inr: CoproductViewTraverse where T: CoproductViewTraverse {
    typealias Out = T.Out
    
    func traverse() -> T.Out {
        return tail.traverse()
    }
}

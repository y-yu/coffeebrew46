import SwiftUI

extension Bool {
    public var getOnlyBinding: Binding<Bool> {
        Binding(
            get: { self },
            set: { _ in () }
        )
    }
}

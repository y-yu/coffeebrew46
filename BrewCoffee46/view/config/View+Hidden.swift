import SwiftUI

extension View {
    public func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

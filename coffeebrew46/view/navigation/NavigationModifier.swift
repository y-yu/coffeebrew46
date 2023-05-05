import SwiftUI

struct NavigationModifier: ViewModifier {
    @Binding var path: [Route]

    @ViewBuilder
    fileprivate func coordinator(_ route: Route) -> some View {
        switch route {
        case .config:
            ConfigView()
        case .stopwatch:
            StopwatchView()
        case .saveLoad:
            SaveLoadView()
        }
    }

    func body(content: Content) -> some View {
        NavigationStack(path: $path) {
            content
                .navigationDestination(for: Route.self) { route in
                    coordinator(route)
                }
        }
    }
}

extension View {
    func navigation(path: Binding<[Route]>) -> some View {
        self.modifier(NavigationModifier(path: path))
    }
}

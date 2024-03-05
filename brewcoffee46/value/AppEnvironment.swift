import Foundation
import SwiftUI

final class AppEnvironment: ObservableObject {
    @Published var selectedTab: Route = .stopwatch
    @Published var isTimerStarted: Bool = false
    @Published var stopwatchPath: [Route] = []
    @Published var configPath: [Route] = []
    @Published var infoPath: [Route] = []
    @Published var beforeChecklistPath: [Route] = []

    var minWidth: Double

    init() {
        switch UIDevice.current.userInterfaceIdiom {
        case .pad:
            self.minWidth = 800
        default:
            self.minWidth = 500
        }
    }

    var tabSelection: Binding<Route> {
        Binding { [weak self] in
            self?.selectedTab ?? .stopwatch
        } set: { [weak self] newValue in
            self?.selectedTab = newValue
        }
    }
}

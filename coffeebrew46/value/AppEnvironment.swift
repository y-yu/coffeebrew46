import Foundation
import SwiftUI

enum Route {
    case stopwatch
    case config
}

final class AppEnvironment: ObservableObject {
    @Published var selectedTab: Route = .stopwatch
    @Published var isTimerStarted: Bool = false
    @Published var stopwatchPath: [Route] = []
    @Published var configPath: [Route] = []
    
    var tabSelection: Binding<Route> {
        Binding { [weak self] in
            self?.selectedTab ?? .stopwatch
        } set: { [weak self] newValue in
            self?.selectedTab = newValue
        }
    }
}

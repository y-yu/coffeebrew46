import SwiftUI

struct RootView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    var body: some View {
        TabView(selection: appEnvironment.tabSelection) {
            StopwatchView()
                .tabItem {
                    Image(systemName: "stopwatch")
                    Text("Stopwatch")
                }
                .tag(Route.stopwatch)
            ConfigView()
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text("Configuration")
                }
                .tag(Route.config)
        }
    }
}

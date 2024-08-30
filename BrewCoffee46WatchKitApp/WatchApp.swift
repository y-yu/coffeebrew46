import SwiftUI

@main
struct WatchApp: App {
    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(CurrentConfigViewModel())
                .environmentObject(WatchKitAppEnvironment())
        }
    }
}

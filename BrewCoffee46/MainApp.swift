import BrewCoffee46Core
import Factory
import SwiftUI

public let universalLinksQueryItemName: String = "config"

@main
struct MainApp: App {
    @Injected(\.jwtService) private var jwtService

    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @ObservedObject var appEnvironment: AppEnvironment = .init()
    @ObservedObject var viewModel: CurrentConfigViewModel = CurrentConfigViewModel()

    var body: some Scene {
        WindowGroup {
            ZStack {
                RootView()
                    .environmentObject(appEnvironment)
                    .environmentObject(viewModel)
            }
            .onOpenURL { url in
                if let jwt = URLComponents(url: url, resolvingAgainstBaseURL: true)?.queryItems?.first(where: {
                    $0.name == universalLinksQueryItemName
                })?.value {
                    jwtService.verify(jwt: jwt).forEach { configClaims in
                        appEnvironment.importedConfigClaims = configClaims
                        appEnvironment.selectedTab = .config
                        appEnvironment.configPath = [.config, .universalLinksImport]
                    }
                }
            }
        }
    }
}

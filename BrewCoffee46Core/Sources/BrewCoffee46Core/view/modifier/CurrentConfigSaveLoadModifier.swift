import Factory
import SwiftUI

/// When leave/back app, load/save the current configuration.
public struct CurrentConfigSaveLoadModifier: ViewModifier {
    @Binding var currentConfig: Config
    @Binding var errors: String

    @Injected(\.saveLoadConfigService) private var saveLoadConfigService
    @Environment(\.scenePhase) private var scenePhase

    public func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { _, phase in
                switch phase {
                case .background:
                    saveLoadConfigService
                        .saveCurrentConfig(config: currentConfig)
                        .recoverWithErrorLog(&errors)
                case .inactive:
                    switch scenePhase {
                    case .active:
                        saveLoadConfigService
                            .saveCurrentConfig(config: currentConfig)
                            .recoverWithErrorLog(&errors)
                    case .background:
                        ()
                    default:
                        ()
                    }
                case .active:
                    saveLoadConfigService
                        .loadCurrentConfig()
                        .map { $0.map { currentConfig = $0 } }
                        .recoverWithErrorLog(&errors)
                @unknown default:
                    ()
                }
            }
    }
}

extension View {
    public func currentConfigSaveLoadModifier(_ config: Binding<Config>, _ errors: Binding<String>) -> some View {
        self.modifier(
            CurrentConfigSaveLoadModifier(currentConfig: config, errors: errors)
        )
    }
}

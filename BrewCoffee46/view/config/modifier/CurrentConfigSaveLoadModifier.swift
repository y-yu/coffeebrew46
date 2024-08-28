import Factory
import SwiftUI

/// When leave/back app, load/save the current configuration.
struct CurrentConfigSaveLoadModifier: ViewModifier {
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    @Injected(\.saveLoadConfigService) private var saveLoadConfigService
    @Environment(\.scenePhase) private var scenePhase

    func body(content: Content) -> some View {
        content
            .onChange(of: scenePhase) { phase in
                switch phase {
                case .background:
                    saveLoadConfigService
                        .saveCurrentConfig(config: viewModel.currentConfig)
                        .recoverWithErrorLog(&viewModel.errors)
                case .inactive:
                    switch scenePhase {
                    case .active:
                        saveLoadConfigService
                            .saveCurrentConfig(config: viewModel.currentConfig)
                            .recoverWithErrorLog(&viewModel.errors)
                    case .background:
                        ()
                    default:
                        ()
                    }
                case .active:
                    saveLoadConfigService
                        .loadCurrentConfig()
                        .map { $0.map { viewModel.currentConfig = $0 } }
                        .recoverWithErrorLog(&viewModel.errors)
                @unknown default:
                    ()
                }
            }
    }
}

extension View {
    func currentConfigSaveLoadModifier() -> some View {
        self.modifier(CurrentConfigSaveLoadModifier())
    }
}

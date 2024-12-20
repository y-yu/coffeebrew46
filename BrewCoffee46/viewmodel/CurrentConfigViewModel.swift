import BrewCoffee46Core
import Factory
import SwiftUI

@MainActor
final class CurrentConfigViewModel: ObservableObject {
    @Injected(\.validateInputService) private var validateInputService
    @Injected(\.calculateDripInfoService) private var calculateDripInfoService
    @Injected(\.dateService) private var dateService

    @Published var currentConfig: Config = Config.defaultValue() {
        didSet {
            // When the `currentConfig` will be updated then we want to update `currentConfigLastUpdatedAt` also
            // so the this check is to avoid meaningless update.
            if oldValue != currentConfig {
                let result = validateInputService.validate(config: currentConfig)
                switch result {
                case .success():
                    currentConfigLastUpdatedAt = dateService.nowEpochTimeMillis()
                    calculateScale()
                case let .failure(es):
                    errors = "\(es.toArray().map({e in e.getMessage()}))"
                    currentConfig = oldValue
                }
            }
        }
    }
    @Published var currentConfigLastUpdatedAt: UInt64? = .none
    @Published var errors: String = ""
    @Published var pointerInfo: PointerInfo = PointerInfo.defaultValue()

    init() {}

    init(_ config: Config) {
        currentConfig = config
    }

    // This function calculate parameters for the scale view.
    private func calculateScale() -> Void {
        let dripInfo = calculateDripInfoService.calculate(currentConfig)

        self.pointerInfo = PointerInfo(dripInfo)
    }
}

import BrewCoffee46Core
import Factory
import SwiftUI

final class CurrentConfigViewModel: ObservableObject {
    @Injected(\.validateInputService) private var validateInputService
    @Injected(\.calculateDripInfoService) private var calculateDripInfoService

    @Published var currentConfig: Config = Config.defaultValue {
        didSet {
            let result = validateInputService.validate(config: currentConfig)
            switch result {
            case .success():
                calculateScale()
            case let .failure(es):
                errors = "\(es.toArray().map({e in e.getMessage()}))"
                currentConfig = oldValue
            }
        }
    }
    @Published var errors: String = ""
    @Published var pointerInfo: PointerInfo = PointerInfo.init()

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

extension CurrentConfigViewModel {
    // TODO: This logic should be injected as dependency!
    func toDegree(_ progressTime: Double) -> Double {
        if progressTime < 0 {
            return 0
        } else if progressTime > currentConfig.totalTimeSec {
            return 360
        } else if progressTime <= currentConfig.steamingTimeSec {
            // In this case, at 1st shot.
            return progressTime / currentConfig.steamingTimeSec * pointerInfo.pointerDegrees[1]
        } else {
            if currentConfig.firstWaterPercent < 1 && progressTime <= pointerInfo.dripInfo.dripTimings[2].dripAt {
                // At 2nd shot where there are 2 shots on first 40% drip.
                return (progressTime - currentConfig.steamingTimeSec)
                    * (pointerInfo.pointerDegrees[2] - pointerInfo.pointerDegrees[1])
                    / (pointerInfo.dripInfo.dripTimings[2].dripAt - currentConfig.steamingTimeSec) + pointerInfo.pointerDegrees[1]
            } else if currentConfig.firstWaterPercent < 1 {
                // After 2nd shot where there are 2 shots on first 40% drip.
                return
                    ((progressTime - pointerInfo.dripInfo.dripTimings[2].dripAt)
                    / (currentConfig.totalTimeSec - pointerInfo.dripInfo.dripTimings[2].dripAt))
                    * (360.0 - pointerInfo.pointerDegrees[2]) + pointerInfo.pointerDegrees[2]
            } else {
                // After 2nd shot where there are 1 shot on first 40% drip.
                return ((progressTime - currentConfig.steamingTimeSec) / (currentConfig.totalTimeSec - currentConfig.steamingTimeSec))
                    * (360.0 - pointerInfo.pointerDegrees[1]) + pointerInfo.pointerDegrees[1]
            }
        }
    }

    // TODO: This logic should be injected as dependency!
    func toProgressTime(_ degree: Double) -> Double {
        if degree > 360 {
            return currentConfig.totalTimeSec
        } else if degree <= pointerInfo.pointerDegrees[1] {
            // At 1st shot.
            return currentConfig.steamingTimeSec * degree / pointerInfo.pointerDegrees[1]
        } else {
            let fortyPercentDegree = 144.0  // 360 * 0.4

            if currentConfig.firstWaterPercent < 1 && degree <= fortyPercentDegree {
                // At 2nd shot where there are 2 shots on first 40% drip.
                return (pointerInfo.dripInfo.dripTimings[2].dripAt - currentConfig.steamingTimeSec)
                    * (degree - pointerInfo.pointerDegrees[1]) / (fortyPercentDegree - pointerInfo.pointerDegrees[1])
                    + currentConfig.steamingTimeSec
            } else if currentConfig.firstWaterPercent < 1 {
                // After 2nd shot where there are 2 shots on first 40% drip.
                return (currentConfig.totalTimeSec - pointerInfo.dripInfo.dripTimings[2].dripAt) * (degree - fortyPercentDegree)
                    / (360 - pointerInfo.pointerDegrees[2]) + pointerInfo.dripInfo.dripTimings[2].dripAt
            } else {
                // After 2nd shot where there are 2 shots on first 40% drip.
                return (currentConfig.totalTimeSec - pointerInfo.dripInfo.dripTimings[1].dripAt) * (degree - fortyPercentDegree)
                    / (360 - pointerInfo.pointerDegrees[1]) + pointerInfo.dripInfo.dripTimings[1].dripAt
            }
        }
    }

    func getNthPhase(progressTime: Double) -> Int {
        if progressTime < 0 {
            return 0
        }

        if let nth = pointerInfo.dripInfo.dripTimings.firstIndex(where: { e in
            e.dripAt > progressTime
        }) {
            return nth - 1
        } else {
            if progressTime >= currentConfig.totalTimeSec {
                return pointerInfo.pointerDegrees.count
            } else {
                return pointerInfo.pointerDegrees.count - 1
            }
        }
    }
}

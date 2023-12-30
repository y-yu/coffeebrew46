import SwiftUI
import Factory

final class CurrentConfigViewModel: ObservableObject {
    @Published var currentConfig: Config = Config.init() {
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
    @Published var pointerInfoViewModels: PointerInfoViewModels = PointerInfoViewModels.defaultValue()
    
    @Injected(\.validateInputService) private var validateInputService
    @Injected(\.calculateBoiledWaterAmountService) private var calculateBoiledWaterAmountService
    
    // This function calculate parameters for the scale view.
    private func calculateScale() -> Void {
        self.pointerInfoViewModels =
            calculateBoiledWaterAmountService.calculate(config: currentConfig)
    }
}

extension CurrentConfigViewModel {
    // TODO: This logic should be injected as dependency!
    func toDegree(_ progressTime: Double) -> Double {
        if (progressTime < 0) {
            return 0
        } else if (progressTime > currentConfig.totalTimeSec) {
            return 360
        } else if (progressTime <= currentConfig.steamingTimeSec) {
            // In this case, at 1st shot.
            return progressTime /  currentConfig.steamingTimeSec * pointerInfoViewModels.pointerInfo[1].degree
        } else {
            if (currentConfig.firstWaterPercent < 1 && progressTime <= pointerInfoViewModels.pointerInfo[2].dripAt) {
                // At 2nd shot where there are 2 shots on first 40% drip.
                return (progressTime - currentConfig.steamingTimeSec) * (pointerInfoViewModels.pointerInfo[2].degree - pointerInfoViewModels.pointerInfo[1].degree) / (pointerInfoViewModels.pointerInfo[2].dripAt - currentConfig.steamingTimeSec) + pointerInfoViewModels.pointerInfo[1].degree
            } else if (currentConfig.firstWaterPercent < 1) {
                // After 2nd shot where there are 2 shots on first 40% drip.
                return ((progressTime - pointerInfoViewModels.pointerInfo[2].dripAt) / (currentConfig.totalTimeSec - pointerInfoViewModels.pointerInfo[2].dripAt)) * (360.0 - pointerInfoViewModels.pointerInfo[2].degree) + pointerInfoViewModels.pointerInfo[2].degree
            } else {
                // After 2nd shot where there are 1 shot on first 40% drip.
                return ((progressTime - currentConfig.steamingTimeSec) / (currentConfig.totalTimeSec - currentConfig.steamingTimeSec)) * (360.0 - pointerInfoViewModels.pointerInfo[1].degree) + pointerInfoViewModels.pointerInfo[1].degree
            }
        }
    }
    
    // TODO: This logic should be injected as dependency!
    func toProgressTime(_ degree: Double) -> Double {
        if (degree > 360) {
            return currentConfig.totalTimeSec
        } else if (degree <= pointerInfoViewModels.pointerInfo[1].degree) {
            // At 1st shot.
            return currentConfig.steamingTimeSec * degree / pointerInfoViewModels.pointerInfo[1].degree
        } else {
            let fortyPercentDegree = 144.0 // 360 * 0.4
            
            if (currentConfig.firstWaterPercent < 1 && degree <= fortyPercentDegree) {
                // At 2nd shot where there are 2 shots on first 40% drip.
                return (pointerInfoViewModels.pointerInfo[2].dripAt - currentConfig.steamingTimeSec) * (degree - pointerInfoViewModels.pointerInfo[1].degree) / (fortyPercentDegree - pointerInfoViewModels.pointerInfo[1].degree) + currentConfig.steamingTimeSec
            } else if (currentConfig.firstWaterPercent < 1) {
                // After 2nd shot where there are 2 shots on first 40% drip.
                return (currentConfig.totalTimeSec - pointerInfoViewModels.pointerInfo[2].dripAt) * (degree - fortyPercentDegree) / (360 - pointerInfoViewModels.pointerInfo[2].degree) + pointerInfoViewModels.pointerInfo[2].dripAt
            } else {
                // After 2nd shot where there are 2 shots on first 40% drip.
                return (currentConfig.totalTimeSec - pointerInfoViewModels.pointerInfo[1].dripAt) * (degree - fortyPercentDegree) / (360 - pointerInfoViewModels.pointerInfo[1].degree) + pointerInfoViewModels.pointerInfo[1].dripAt
            }
        }
    }
    
    func getNthPhase(progressTime: Double) -> Int {
        if (progressTime < 0) {
            return 0
        }
        
        if let nth = pointerInfoViewModels.pointerInfo.firstIndex(where: { e in
            e.dripAt > progressTime
        }) {
            return nth - 1
        } else {
            if (progressTime >= currentConfig.totalTimeSec) {
                return pointerInfoViewModels.pointerInfo.count
            } else {
                return pointerInfoViewModels.pointerInfo.count - 1
            }
        }
    }
}

import SwiftUI

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
    
    @Published var pointerInfoViewModels: PointerInfoViewModels =
        PointerInfoViewModels.defaultValue
    
    // For DI
    private let validateInputService: ValidateInputService
    private let calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependencies
    // which are required to do my business logic.
    init(
        validateInputService: ValidateInputService,
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    ) {
        self.validateInputService = validateInputService
        self.calculateBoiledWaterAmountService = calculateBoiledWaterAmountService
    }
    
    // This function calculate parameters for the scale view.
    private func calculateScale() -> Void {
        self.pointerInfoViewModels =
            calculateBoiledWaterAmountService.calculate(config: currentConfig)
    }
}

extension CurrentConfigViewModel {
    func endDegree(_ progressTime: Double) -> Double {
        if (progressTime > currentConfig.totalTimeSec) {
            return 360
        } else if (progressTime <= currentConfig.steamingTimeSec) {
            return progressTime /  currentConfig.steamingTimeSec * pointerInfoViewModels.pointerInfo[1].degree
        } else {
            let withoutSteamingPerOther = (Double(currentConfig.totalTimeSec) - currentConfig.steamingTimeSec) / Double(pointerInfoViewModels.pointerInfo.count - 1)
            
            if (currentConfig.firstWaterPercent < 1 && progressTime <= withoutSteamingPerOther + currentConfig.steamingTimeSec) {
                return (progressTime - currentConfig.steamingTimeSec) / withoutSteamingPerOther * (pointerInfoViewModels.pointerInfo[2].degree - pointerInfoViewModels.pointerInfo[1].degree) + pointerInfoViewModels.pointerInfo[1].degree
            } else if (currentConfig.firstWaterPercent < 1) {
                let firstAndSecond = currentConfig.steamingTimeSec + withoutSteamingPerOther
                
                return ((progressTime - firstAndSecond) / (currentConfig.totalTimeSec - firstAndSecond)) * (360.0 - pointerInfoViewModels.pointerInfo[2].degree) + pointerInfoViewModels.pointerInfo[2].degree
            } else {
                return ((progressTime - currentConfig.steamingTimeSec) / (currentConfig.totalTimeSec - currentConfig.steamingTimeSec)) * (360.0 - pointerInfoViewModels.pointerInfo[1].degree) + pointerInfoViewModels.pointerInfo[1].degree
            }
        }
    }
}

extension CurrentConfigViewModel {
    func getNthPhase(progressTime: Double) -> Int {
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

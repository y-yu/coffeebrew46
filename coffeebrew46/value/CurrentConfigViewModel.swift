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
    func endDegree(_ progressTime: Int) -> Double {
        let pt = Double(progressTime)
        if (pt <= currentConfig.steamingTimeSec) {
            return pt /  currentConfig.steamingTimeSec * pointerInfoViewModels.pointerInfo[1].degree
        } else {
            let withoutSteamingPerOther = (Double(currentConfig.totalTimeSec) - currentConfig.steamingTimeSec) / Double(pointerInfoViewModels.pointerInfo.count - 1)
            
            if (pt <= withoutSteamingPerOther + currentConfig.steamingTimeSec) {
                return (pt - currentConfig.steamingTimeSec) / withoutSteamingPerOther * (pointerInfoViewModels.pointerInfo[2].degree - pointerInfoViewModels.pointerInfo[1].degree) + pointerInfoViewModels.pointerInfo[1].degree
            } else {
                let firstAndSecond = currentConfig.steamingTimeSec + withoutSteamingPerOther
                
                return pt > currentConfig.totalTimeSec ? 360.0 : ((pt - firstAndSecond) / (currentConfig.totalTimeSec - firstAndSecond)) * (360.0 - pointerInfoViewModels.pointerInfo[2].degree) + pointerInfoViewModels.pointerInfo[2].degree
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

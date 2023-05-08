import SwiftUI

final class CurrentConfigViewModel: ObservableObject {
    private static let colors: Array<Color> =
        [
            .cyan,
            .green,
            .red,
            .blue,
            .orange,
            .purple,
            .yellow,
            .brown,
            .black
        ]
    
    @Published var currentConfig: Config = Config.init() {
        didSet {
            let result = validateInputService.validate(config: currentConfig)
            switch result {
            case .success():
                calculateScale()
            case let .failure(es):
                errors = "\(es.toArray())"
                currentConfig = oldValue
            }
        }
    }
    
    @Published var errors: String = ""
    
    @Published var pointerInfoViewModels: PointerInfoViewModels =
        .withColorAndDegrees(
            (90, colors[0], 0.0),
            (180, colors[1], 72.0),
            (270, colors[2], 144.0),
            (360, colors[3], 216.0),
            (450, colors[4], 288.0)
        )
    
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
        let waterAmount = calculateBoiledWaterAmountService.calculate(config: currentConfig)
        let totalWaterAmount = currentConfig.totalWaterAmount()
        
        let values = [
            waterAmount.fortyPercent.0,
            waterAmount.fortyPercent.1
        ] + waterAmount.sixtyPercent.toArray()
        
        let colorAndDegreesArray =
            values.enumerated().reduce(
                
                (
                    (0.0, 0.0), // (degree, value)
                    Array<(Double, Color, Double)>.init()
                ),
                { (acc, element) in
                    var (prev, arr) = acc
                    let (degree, value) = prev
                    let (i, v) = element
                    let d = (v / totalWaterAmount) * 360 + degree
                    
                    arr.append((value + v, CurrentConfigViewModel.colors[i], degree))
                    
                    return ((d, value + v), arr)
                }
            ).1
        
        pointerInfoViewModels =
            pointerInfoViewModels.withColorAndDegrees(colorAndDegreesArray)
    }
}

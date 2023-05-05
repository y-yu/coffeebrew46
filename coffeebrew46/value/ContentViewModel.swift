import SwiftUI

final class ContentViewModel: ObservableObject {
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
            calculateScale()
        }
    }
    
    @Published var pointerInfoViewModels: PointerInfoViewModels =
        .withColorAndDegrees(
            (90, colors[0], 0.0),
            (180, colors[1], 72.0),
            (270, colors[2], 144.0),
            (360, colors[3], 216.0),
            (450, colors[4], 288.0)
        )
    
    // For DI
    private let calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    // private let boiledWaterAmountPresenter: BoiledWaterAmountPresenterImplType
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependencies
    // which are required to do my business logic.
    init(
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    ) {
        self.calculateBoiledWaterAmountService = calculateBoiledWaterAmountService
    }
    
    // This function calculate parameters for the scale view.
    private func calculateScale() -> Void {
        // Convert input text to Double
        let weightEither: ResultNel<Double, CoffeeError> =
            ResultNel.success(currentConfig.coffeeBeansWeight)
        
        // Calc and binding boiledWaterAmountText
        let result: ResultNel<WaterAmount, CoffeeError> =
            weightEither.flatMap { (weight) in
                calculateBoiledWaterAmountService
                    .calculate(
                        coffeeBeansWeight: weight,
                        firstBoiledWaterAmount: currentConfig.firstWaterPercent * currentConfig.coffeeBeansWeight * (currentConfig.waterToCoffeeBeansWeightRatio * 2 / 5),
                        numberOf6: Int(currentConfig.partitionsCountOf6),
                        coffeeBeansWeightRatio: Int(currentConfig.waterToCoffeeBeansWeightRatio)
                )
            }

        result.forEach { r in
            let totalWaterAmount = currentConfig.totalWaterAmount()
            
            let values = [
                r.fourtyPercent.0,
                r.fourtyPercent.1
            ] + r.sixtyPercent.toArray()
            
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
                        
                        arr.append((value + v, ContentViewModel.colors[i], degree))
                        
                        return ((d, value + v), arr)
                    }
                ).1
            
            pointerInfoViewModels =
                pointerInfoViewModels.withColorAndDegrees(colorAndDegreesArray)
        }
    }
}

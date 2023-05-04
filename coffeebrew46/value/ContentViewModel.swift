import SwiftUI

final class ContentViewModel: ObservableObject {
    // Inupt text.
    @Published var coffeeBeansWeight: Double = 30.0 {
        didSet {
            calculateScale()
        }
    }
    
    private let colors: Array<Color> =
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
    
    @Published var pointerInfoViewModels: PointerInfoViewModels =
        .withColorAndDegrees(
            (90, .cyan, 0.0),
            (180, .green, 72.0),
            (270, .red, 144.0),
            (360, .blue, 216.0),
            (450, .orange, 288.0)
        )
    
    @Published var numberOf6: Double = 3.0 {
        didSet {
            calculateScale()
        }
    }
    
    @Published var firstBoiledWaterPercent: Double = 0.5 {
        didSet {
            calculateScale()
        }
    }
    
    @Published var totalWaterAmount: Double = 300
    
    @Published var totalTime: Double = 210
    
    @Published var steamingTime: Double = 55
    
    @Published var coffeeBeansWeightRatio: Double = 15 {
        didSet {
            calculateScale()
        }
    }
    
    // For DI
    private let calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    // private let boiledWaterAmountPresenter: BoiledWaterAmountPresenterImplType
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependecies
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
            ResultNel.success(coffeeBeansWeight)
        
        // Calc and binding boiledWaterAmountText
        let result: ResultNel<BoiledWaterAmount, CoffeeError> =
            weightEither.flatMap { (weight) in
                calculateBoiledWaterAmountService
                    .calculate(
                        coffeeBeansWeight: weight,
                        firstBoiledWaterAmount: firstBoiledWaterPercent * coffeeBeansWeight * (coffeeBeansWeightRatio * 2 / 5),
                        numberOf6: Int(numberOf6),
                        coffeeBeansWeightRatio: Int(coffeeBeansWeightRatio)
                )
            }

        result.forEach { r in
            totalWaterAmount = r.totalAmount()
            
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
                        
                        arr.append((value + v, colors[i], degree))
                        
                        return ((d, value + v), arr)
                    }
                ).1
            
            pointerInfoViewModels =
                pointerInfoViewModels.withColorAndDegrees(colorAndDegreesArray)
        }
    }
}

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
            .green,
            .red,
            .blue,
            .orange,
            .purple,
            .cyan,
            .pink,
            .yellow,
            .brown,
            .black
        ]
    
    @Published var pointerInfoViewModels: PointerInfoViewModels =
        .withColorAndDegrees(
            (.green, 72.0),
            (.red, 144.0),
            (.blue, 216.0),
            (.orange, 288.0),
            (.purple, 360.0)
        ) {
            didSet {
                calculateFromScale()
            }
        }
    
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
    
    // For DI
    private let calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    // private let boiledWaterAmountPresenter: BoiledWaterAmountPresenterImplType
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependecies
    // which are required to do my business logic.
    init(
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
        // ,boiledWaterAmountPresenter: BoiledWaterAmountPresenterImplType
    ) {
        self.calculateBoiledWaterAmountService = calculateBoiledWaterAmountService
        //self.boiledWaterAmountPresenter = boiledWaterAmountPresenter
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
                        firstBoiledWaterAmount: firstBoiledWaterPercent * coffeeBeansWeight * 3 * 2,
                        numberOf6: Int(numberOf6)
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
                    (0.0, Array<(Color, Double)>.init()),
                    { (acc, element) in
                        var (degree, arr) = acc
                        let (i, v) = element
                        let d = (v / totalWaterAmount) * 360 + degree
                        
                        arr.append((colors[i], d))
                        
                        return (d, arr)
                    }
                ).1
            
            pointerInfoViewModels =
                pointerInfoViewModels.withColorAndDegrees(colorAndDegreesArray)
        }
    }
    
    private func calculateFromScale() -> Void {
        let fourtyPercent =
            pointerInfoViewModels
                .pointerInfo
                .prefix(2)
        
        let result = calculateBoiledWaterAmountService.calculateFromNel(
            values: pointerInfoViewModels
                .pointerInfo
                .map { (e) in
                    e.degrees / 360
                }
        )
        
        
    }
}

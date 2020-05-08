import SwiftUI

final class ContentViewModel<
    BoiledWaterAmountPresenterImplType: BoiledWaterAmountPresenter
>: ObservableObject {
    // Inupt text
    @Published var coffeeBeansWeight: Double = 0.0 {
        didSet {
            calculate(coffeeBeansWeight)
        }
    }
    @Published var firstShotBoiledWaterAmount: Double = 0.0 {
        didSet {
            
        }
    }
    
    @Published var scaleDegrees: Double = 0.0

    // Output to the View
    @Published private(set) var boiledWaterAmountText: BoiledWaterAmountPresenterImplType.ResultView =
        BoiledWaterAmountPresenterImplType.unit
    
    // For DI
    private let calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService
    private let boiledWaterAmountPresenter: BoiledWaterAmountPresenterImplType
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependecies
    // which are required to do my business logic.
    init(
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountService,
        boiledWaterAmountPresenter: BoiledWaterAmountPresenterImplType
    ) {
        self.calculateBoiledWaterAmountService = calculateBoiledWaterAmountService
        self.boiledWaterAmountPresenter = boiledWaterAmountPresenter
    }
    
    // This function generate a view.
    public func calculate(_ coffeeBeansWeight: Double) -> Void {
        // Convert input text to Double
        let weightEither: ResultNel<Double, CoffeeError> =
            ResultNel.success(coffeeBeansWeight)
            // Double(textInput).toResultNel(CoffeeError.CoffeeBeansWeightIsNotNumberError)
        
        // Calc and binding boiledWaterAmountText
        let result: ResultNel<BoiledWaterAmount, CoffeeError> =
            weightEither.flatMap { (weight) in
                calculateBoiledWaterAmountService
                    .calculate(
                        coffeeBeansWeight: weight,
                        // This is a sloppy impletementation!!!!!!!!!!!!!!
                        // TODO: Fix it
                        firstBoiledWaterAmount: weight / 2,
                        numberOf6: 3
                )
            }

        self.boiledWaterAmountText = self.boiledWaterAmountPresenter.show(result: result)
    }
}

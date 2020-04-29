import SwiftUI

final class ContentViewModel<
    BoiledWaterAmountPresenterImplType: BoiledWaterAmountPresenter
>: ObservableObject {
    // Inupt text
    @Published var textInput: String = "" {
        didSet {
            calculate(textInput)
        }
    }

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
    public func calculate(_ textInput: String) -> Void {
        // Convert input text to Double
        let weightEither: Result<Double, CoffeeError> =
            Double(textInput)
                .toResult(CoffeeError.CoffeeBeansWeightIsNotNumberError(.none)) // XCode says it is an error but it's a lie!
        
        // Calc and binding boiledWaterAmountText
        let result: Result<BoiledWaterAmount, CoffeeError> =
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

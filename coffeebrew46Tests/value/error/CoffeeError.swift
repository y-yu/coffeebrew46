
import CoffeeBrew46

extension CoffeeBrew46.CoffeeError: Equatable {
    public static func == (lhs: CoffeeBrew46.CoffeeError, rhs: CoffeeBrew46.CoffeeError) -> Bool {
        return switch (lhs, rhs) {
        case (.coffeeBeansWeightUnderZeroError, .coffeeBeansWeightUnderZeroError): true
        case (.coffeeBeansWeightIsNotNumberError, .coffeeBeansWeightIsNotNumberError): true
        case (.waterAmountIsTooLessError, .waterAmountIsTooLessError): true
        case (.first40PercentWaterAmountExceededWholeWaterAmountError, .first40PercentWaterAmountExceededWholeWaterAmountError): true
        case (.partitionsCountOf6IsNeededAtLeastOne, .partitionsCountOf6IsNeededAtLeastOne): true
        case (.steamingTimeIsTooMuchThanTotal, .steamingTimeIsTooMuchThanTotal): true
        case (.firstWaterPercentIsZeroError, .firstWaterPercentIsZeroError): true
        case (.loadedConfigIsNotCompatible, .loadedConfigIsNotCompatible): true
        case (.jsonError(_), .jsonError(_)): 
            // This case is too much ad-hoc since ignore the difference of `underlying` between `lhs` and `rhs`.
            // That's the why this `Equatable` implementation is put test code rather than main.
            true
        default: false
        }
    }
}

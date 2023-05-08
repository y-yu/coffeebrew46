/**
 # Validation for the config.
 */
protocol ValidateInputService {
    func validate(
        config: Config
    ) -> ResultNel<Void, CoffeeError>
}

class ValidateInputServiceImpl: ValidateInputService {
    func validate(
        config: Config
    ) -> ResultNel<Void, CoffeeError> {
        let validatedTuple =
            validateCoffeeBeansWeight(config.coffeeBeansWeight) |+|
            validationNumberOf6(Int(config.partitionsCountOf6))
            
        return validatedTuple.map { _ in
            ()
        }
    }

    // Coffee beans weight must be greater than 0g.
    private func validateCoffeeBeansWeight(
        _ coffeeBeansWeight: Double
    ) -> ResultNel<Double, CoffeeError> {
        coffeeBeansWeight > 0 ?
            ResultNel.success(coffeeBeansWeight) :
            CoffeeError.CoffeeBeansWeightUnderZeroError.toFailureNel()
    }
    
    // The first boiled water amount is greater than 0cc and
    // less than or equal 40% of whole water.
    private func validateFirstBoiledWaterAmount(
        // These are the same type `Double` so
        // not to allow the caller to omit name in order to prement from mistake.
        wholeBoiledWaterAmount: Double,
        firstBoiledWaterAmount: Double
    ) -> ResultNel<Double, CoffeeError> {
        if (firstBoiledWaterAmount <= wholeBoiledWaterAmount && firstBoiledWaterAmount >= 0) {
            return ResultNel.success(firstBoiledWaterAmount)
        } else if (firstBoiledWaterAmount <= wholeBoiledWaterAmount) {
            return CoffeeError.BoiledWaterAmountIsTooLessError.toFailureNel()
        } else {
            return CoffeeError.FirstShotBoiledWaterAmountExceededWholeAmountError.toFailureNel()
        }
    }
    
    private func validationNumberOf6(
        _ numberOf6: Int
    ) -> ResultNel<Int, CoffeeError> {
        numberOf6 > 0 ?
            ResultNel.success(numberOf6) :
            CoffeeError.ShotTimesNumberIsNeededAtLeastOne.toFailureNel()
    }
}

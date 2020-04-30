/**
 # Validation for the inputs.
 */
protocol ValidateInputService {
    func validate(
        coffeeBeansWeight: Double,
        // `wholeBoiledWaterAmount` can be calcurated from `coffeeBeansWeight`
        // but this validation shouldn't have the logic.
        wholeBoiledWaterAmount: Double,
        firstBoiledWaterAmount: Double,
        numberOf6: Int
    ) -> ResultNel<ValidatedInput, CoffeeError>
}

class ValidateInputServiceImpl: ValidateInputService {
    func validate(
        coffeeBeansWeight: Double,
        wholeBoiledWaterAmount: Double,
        firstBoiledWaterAmount: Double,
        numberOf6: Int
    ) -> ResultNel<ValidatedInput, CoffeeError> {
        let validatedTuple =
            validateCoffeeBeansWeight(coffeeBeansWeight) |+|
            validateFirstBoiledWaterAmount(
                wholeBoiledWaterAmount: wholeBoiledWaterAmount,
                firstBoiledWaterAmount: firstBoiledWaterAmount
            ) |+|
            validationNumberOf6(numberOf6)
            
        return validatedTuple.map { (tuple: (Double, (Double, Int))) in
            let (coffeeBeansWeight, (firstBoiledWaterAmount, numberOf6)) = tuple
            
            return ValidatedInput(
                coffeeBeansWeight: coffeeBeansWeight,
                firstBoiledWaterAmount: firstBoiledWaterAmount,
                numberOf6: numberOf6
            )
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

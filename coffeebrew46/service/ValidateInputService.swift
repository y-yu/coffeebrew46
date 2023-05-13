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
            validationNumberOf6(Int(config.partitionsCountOf6)) |+|
            validationTimer(steamingTime: config.steamingTimeSec, totalTime: config.totalTimeSec)
            
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
            CoffeeError.coffeeBeansWeightUnderZeroError.toFailureNel()
    }
    
    private func validationNumberOf6(
        _ numberOf6: Int
    ) -> ResultNel<Int, CoffeeError> {
        numberOf6 > 0 ?
            ResultNel.success(numberOf6) :
            CoffeeError.partitionsCountOf6IsNeededAtLeastOne.toFailureNel()
    }
    
    private func validationTimer(
        steamingTime: Double,
        totalTime: Double
    ) -> ResultNel<Void, CoffeeError> {
        steamingTime < totalTime ?
            ResultNel.success(()) :
            CoffeeError.steamingTimeIsTooMuchThanTotal.toFailureNel()
    }
}

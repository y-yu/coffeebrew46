/*
 # Interface to calculate boiled water amount service
 
 In the '4:6 method', which is one of the berwing coffee methods, invented by TETSU KASUYA,
 the boiled water amount for each step must be calculated only the coffee beans weight.
 This interface is a reprentation of the curriculation.
 */
protocol CalculateBoiledWaterAmountService {
    func calculate(
        coffeeBeansWeight: Double,
        firstBoiledWaterAmount: Double,
        numberOf6: Int
    ) -> Either<CoffeeError, BoiledWaterAmount>
}

// Implementation
class CalculateBoiledWaterAmountServiceImpl: CalculateBoiledWaterAmountService {
    func calculate(
        coffeeBeansWeight: Double,
        firstBoiledWaterAmount: Double,
        numberOf6: Int
    ) -> Either<CoffeeError, BoiledWaterAmount> {
        // This is a sloppy impletementation!!!!!!!!!!!!!!
        // TODO: Fix it
        return (coffeeBeansWeight <= 0 ? Either.Left(CoffeeBeansWeightUnderZeroError()) : Either.Right(
            BoiledWaterAmount(
                totalAmount: coffeeBeansWeight * 15,
                f: { (ta) -> (Double, Double, Double, Double, Double) in
                    (ta / 5, ta / 5, ta / 5, ta / 5, ta / 5)
                }
            )
        ))
    }
}

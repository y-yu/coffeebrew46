/**
 # Interface to calculate boiled water amount service
 
 In the '4:6 method', which is one of the berwing coffee methods, invented by TETSU KASUYA,
 the boiled water amount for each step must be calculated only the coffee beans weight.
 This interface is a reprentation of the curriculation.
 */
protocol CalculateBoiledWaterAmountService {
    func calculate(
        coffeeBeansWeight: Double,
        firstBoiledWaterAmount: Double,
        numberOf6: Int,
        coffeeBeansWeightRatio: Int
    ) -> ResultNel<BoiledWaterAmount, CoffeeError>
    
    // From the scale pointers.
    func calculateFromNel(
        values: Array<Double>,
        coffeeBeansWeightRatio: Int
    ) -> ResultNel<BoiledWaterAmount, CoffeeError>
}

// Implementation
class CalculateBoiledWaterAmountServiceImpl: CalculateBoiledWaterAmountService {
    let validateInputService: ValidateInputService
    
    init(validateInputService: ValidateInputService) {
        self.validateInputService = validateInputService
    }
    
    func calculate(
        coffeeBeansWeight: Double,
        firstBoiledWaterAmount: Double,
        numberOf6: Int,
        coffeeBeansWeightRatio: Int
    ) -> ResultNel<BoiledWaterAmount, CoffeeError> {
        let wholeBoiledWaterAmount = coffeeBeansWeight * Double(coffeeBeansWeightRatio)
        let validatedInput = validateInputService.validate(
            coffeeBeansWeight: coffeeBeansWeight,
            wholeBoiledWaterAmount: wholeBoiledWaterAmount,
            firstBoiledWaterAmount: firstBoiledWaterAmount,
            numberOf6: numberOf6
        )
        
        return validatedInput.map { (input) in
            BoiledWaterAmount(
                fourtyPercent: (
                    firstBoiledWaterAmount,
                    (wholeBoiledWaterAmount * 0.4) - firstBoiledWaterAmount
                ),
                sixtyPercent: {
                    let sixtyAmount = wholeBoiledWaterAmount * 0.6
                    let value = NonEmptyList(
                        head: sixtyAmount / Double(numberOf6),
                        tail: .Nil
                    )

                    func loop(_ acc: NonEmptyList<Double>, _ n: Int) ->  NonEmptyList<Double> {
                        if (n <= 1) {
                            return acc
                        } else {
                            return loop(value ++ acc, n - 1)
                        }
                    }
                    
                    return loop(value, numberOf6)
                }()
            )
        }
    }
    
    func calculateFromNel(
        values: Array<Double>,
        coffeeBeansWeightRatio: Int
    ) -> ResultNel<BoiledWaterAmount, CoffeeError> {
        let wholeBoiledWaterAmount = values.reduce(
            0.0,
            { (acc, v) in acc + v }
        )
        let coffeeBeansWeight = wholeBoiledWaterAmount / Double(coffeeBeansWeightRatio)
        let firstBoiledWaterAmount = values[0]
        
        return calculate(
            coffeeBeansWeight: coffeeBeansWeight,
            firstBoiledWaterAmount: firstBoiledWaterAmount,
            numberOf6: values.count - 2,
            coffeeBeansWeightRatio: coffeeBeansWeightRatio
        )
    }
}

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
        numberOf6: Int
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
        numberOf6: Int
    ) -> ResultNel<BoiledWaterAmount, CoffeeError> {
        let wholeBoiledWaterAmount = coffeeBeansWeight * 15
        let validatedInput = validateInputService.validate(
            coffeeBeansWeight: coffeeBeansWeight,
            wholeBoiledWaterAmount: wholeBoiledWaterAmount,
            firstBoiledWaterAmount: firstBoiledWaterAmount,
            numberOf6: numberOf6
        )
        
        return validatedInput.map { (input) in
            BoiledWaterAmount(
                totalAmount: wholeBoiledWaterAmount,
                f: { (ta) -> (Double, Double, Double, Double, Double) in
                    (ta / 5, ta / 5, ta / 5, ta / 5, ta / 5)
                }
            )
        }
    }
}

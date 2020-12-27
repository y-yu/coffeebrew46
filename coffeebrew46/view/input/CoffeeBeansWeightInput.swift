import Bow
import BowOptics

enum CoffeeBeansWeightInput {
    case update(Double)
    
    case increase(Double)
    
    case decrease(Double)
}

extension CoffeeBeansWeightInput {
    static let contentInputPrism = Prism<ContentInput, CoffeeBeansWeightInput>(
        extract: { contentInput in
            switch contentInput {
            case let .coffeeBeansWeightInput(input):
                return input
            default:
                return nil
            }
        },
        embed: { coffeeBeansWeightInput in
            ContentInput.coffeeBeansWeightInput(coffeeBeansWeightInput)
        }
    )
}

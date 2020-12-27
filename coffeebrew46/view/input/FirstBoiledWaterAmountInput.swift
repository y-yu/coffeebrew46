import Bow
import BowOptics

enum FirstBoiledWaterAmountInput {
    case update(Double)
    
    case increase(Double)
    
    case decrease(Double)
}


extension FirstBoiledWaterAmountInput {
    static let contentInputPrism = Prism<ContentInput, FirstBoiledWaterAmountInput>(
        extract: { contentInput in
            switch contentInput {
            case let .firstBoiledWaterAmountInput(input):
                print("input: \(input)")
                return input
                
            default:
                return nil
            }
        },
        embed: { firstBoiledWaterAmountInput in
            ContentInput.firstBoiledWaterAmountInput(firstBoiledWaterAmountInput)
        }
    )
}

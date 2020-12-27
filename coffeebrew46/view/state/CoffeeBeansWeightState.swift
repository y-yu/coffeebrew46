import Bow
import BowOptics

struct CoffeeBeansWeightState {
    let value: Double
}

extension CoffeeBeansWeightState {
    static let initValue: CoffeeBeansWeightState =
        CoffeeBeansWeightState(value: 0.0)
    
    
    static let contentStateLens = Lens<ContentState, CoffeeBeansWeightState>(
        get: { contentState in contentState.coffeeBeansWeightState },
        set: { contentState, newCoffeeBeansWeightState in
            print("set!!!")
            return ContentState(
                coffeeBeansWeightState: newCoffeeBeansWeightState,
                firstBoiledWaterAmountState: contentState.firstBoiledWaterAmountState
            )
        }
    )

}

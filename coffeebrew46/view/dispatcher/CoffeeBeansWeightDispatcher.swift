import Bow
import BowEffects
import BowArch
import BowOptics

typealias CoffeeBeansWeightDispatcher = StateDispatcher<Any, CoffeeBeansWeightState, CoffeeBeansWeightInput>

let coffeeBeansWeightDispatcher = CoffeeBeansWeightDispatcher.pure { input in
    switch input {
    case let .update(newWeight):
        return .set(
            CoffeeBeansWeightState(value: newWeight)
        )^
        
    case let .increase(weight):
        print("increase!!!!!!!")
        return .modify { previousState in
            CoffeeBeansWeightState(value: previousState.value + weight)
        }^

    case let .decrease(weight):
        return .modify { previousState in
            CoffeeBeansWeightState(value: previousState.value - weight)
        }^
    }
}

let widenCoffeeBeansWeightDispatcher: ContentDispatcher =
    coffeeBeansWeightDispatcher.widen(
        transformState: CoffeeBeansWeightState.contentStateLens,
        transformInput: CoffeeBeansWeightInput.contentInputPrism
    )

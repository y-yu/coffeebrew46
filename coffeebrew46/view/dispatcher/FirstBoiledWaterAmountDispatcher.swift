import Bow
import BowEffects
import BowArch
import BowOptics

typealias FirstBoiledWaterAmountDispatcher = StateDispatcher<Any, FirstBoiledWaterAmountState, FirstBoiledWaterAmountInput>

let firstBoiledWaterAmountDispatcher = FirstBoiledWaterAmountDispatcher.pure { input in
    switch input {
    case let .update(newAmount):
        return .set(
            FirstBoiledWaterAmountState(value: newAmount)
        )^
        
    case let .increase(amount):
        return .modify { previousState in
            FirstBoiledWaterAmountState(value: previousState.value + amount)
        }^

    case let .decrease(amount):
        return .modify { previousState in
            FirstBoiledWaterAmountState(value: previousState.value - amount)
        }^
    }
}

let widenFirstBoiledWaterAmountDispatcher: ContentDispatcher =
    firstBoiledWaterAmountDispatcher.widen(
        transformState: FirstBoiledWaterAmountState.contentStateLens,
        transformInput: FirstBoiledWaterAmountInput.contentInputPrism
    )


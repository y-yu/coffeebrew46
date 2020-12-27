import Bow
import BowOptics

struct FirstBoiledWaterAmountState {
    let value: Double
}

extension FirstBoiledWaterAmountState {
    static let initValue: FirstBoiledWaterAmountState =
        FirstBoiledWaterAmountState(value: 0.0)
    
    static let contentStateLens = Lens<ContentState, FirstBoiledWaterAmountState>(
        get: { contentState in contentState.firstBoiledWaterAmountState },
        set: { contentState, newFirstBoiledWaterAmountState in
            ContentState(
                coffeeBeansWeightState: contentState.coffeeBeansWeightState,
                firstBoiledWaterAmountState: newFirstBoiledWaterAmountState
            )
        }
    )
}


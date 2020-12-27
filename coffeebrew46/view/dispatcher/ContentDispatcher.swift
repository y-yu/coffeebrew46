import Bow
import BowEffects
import BowArch
import BowOptics

typealias ContentDispatcher = StateDispatcher<Any, ContentState, ContentInput>


let combinedDispatcher = ContentDispatcher.empty()
    .combine(widenCoffeeBeansWeightDispatcher)
    .combine(widenFirstBoiledWaterAmountDispatcher)

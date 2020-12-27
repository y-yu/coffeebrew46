import BowArch

typealias FirstBoiledWaterAmountComponent = StoreComponent<Any, FirstBoiledWaterAmountState, FirstBoiledWaterAmountInput, FirstBoiledWaterAmountView>

func firstBoiledWaterAmountComponent(
    _ state: FirstBoiledWaterAmountState = FirstBoiledWaterAmountState.initValue
) -> FirstBoiledWaterAmountComponent {
    FirstBoiledWaterAmountComponent(
        initialState: state,
        dispatcher: firstBoiledWaterAmountDispatcher,
        render: FirstBoiledWaterAmountView.init
    )
}

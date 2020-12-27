import BowArch

typealias ContentComponent = StoreComponent<Any, ContentState, ContentInput, ContentView>

let contentComponent = ContentComponent(
    initialState: ContentState(
        coffeeBeansWeightState: CoffeeBeansWeightState.initValue,
        firstBoiledWaterAmountState: FirstBoiledWaterAmountState.initValue
    ),
    dispatcher: combinedDispatcher,
    render: { state, handle in
        return ContentView(
            state: state,
            coffeeBeansWeightStateHandle: { coffeeBeansWeightState in
                coffeeBeansWeightComponent(coffeeBeansWeightState)
                    .using(
                        handle,
                        transformInput: CoffeeBeansWeightInput.contentInputPrism
                    )
            },
            firstBoiledWaterAmountHandle: { firstBoiledWaterAmountState in
                firstBoiledWaterAmountComponent(firstBoiledWaterAmountState)
                    .using(
                        handle,
                        transformInput: FirstBoiledWaterAmountInput.contentInputPrism
                    )
                
            },
            handle: handle
        )
    }
)


import BowArch

typealias CoffeeBeansWeightComponent = StoreComponent<Any, CoffeeBeansWeightState, CoffeeBeansWeightInput, CoffeeBeansWeightView>

func coffeeBeansWeightComponent(
    _ state: CoffeeBeansWeightState = CoffeeBeansWeightState.initValue
) -> CoffeeBeansWeightComponent {
    CoffeeBeansWeightComponent(
        initialState: state,
        dispatcher: coffeeBeansWeightDispatcher,
        render: CoffeeBeansWeightView.init
    )
}

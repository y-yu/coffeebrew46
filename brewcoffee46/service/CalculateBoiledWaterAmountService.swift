import Factory

/// # Interface to calculate boiled water amount service
///
/// In the '4:6 method', which is one of the brewing coffee methods, invented by Tetsu Kasuya,
/// the boiled water amount for each step must be calculated only the coffee beans weight.
/// This interface is a representation of the calculation.
protocol CalculateBoiledWaterAmountService {
    func calculate(
        config: Config
    ) -> PointerInfoViewModels
}

// Implementation
class CalculateBoiledWaterAmountServiceImpl: CalculateBoiledWaterAmountService {
    func calculate(config: Config) -> PointerInfoViewModels {
        let waterAmount = WaterAmount(
            fortyPercent: (
                config.fortyPercentWaterAmount() * config.firstWaterPercent,
                config.fortyPercentWaterAmount() * (1 - config.firstWaterPercent)
            ),
            sixtyPercent: {
                let sixtyAmount = config.totalWaterAmount() * 0.6
                let value = NonEmptyArray(
                    head: sixtyAmount / Double(config.partitionsCountOf6),
                    tail: []
                )

                func loop(_ acc: NonEmptyArray<Double>, _ n: Int) -> NonEmptyArray<Double> {
                    if n <= 1 {
                        return acc
                    } else {
                        return loop(value ++ acc, n - 1)
                    }
                }

                return loop(value, Int(config.partitionsCountOf6))
            }()
        )
        let totalWaterAmount = config.totalWaterAmount()
        let timeSecPerDripExceptFirst: Double =
            (config.totalTimeSec - config.steamingTimeSec)
            / Double((waterAmount.sixtyPercent.toArray().count + (config.firstWaterPercent < 1 ? 1 : 0)))

        let colorAndDegreesArray =
            waterAmount.toArray().enumerated().reduce(
                (
                    (0.0, 0.0, 0.0),  // (degree, value, dripAt)
                    Array<(Double, Double, Double)>.init()
                ),
                { (acc, elementWithIndex) in
                    let (index, element) = elementWithIndex
                    var (prev, arr) = acc
                    let (degree, value, prevDripAt) = prev
                    let d = (element / totalWaterAmount) * 360 + degree
                    let dripAtAdded = index == 0 ? config.steamingTimeSec : timeSecPerDripExceptFirst

                    arr.append((value + element, degree, prevDripAt))

                    return ((d, value + element, prevDripAt + dripAtAdded), arr)
                }
            ).1

        return PointerInfoViewModels.fromArray(colorAndDegreesArray)
    }
}

extension Container {
    var calculateBoiledWaterAmountService: Factory<CalculateBoiledWaterAmountService> {
        Factory(self) { CalculateBoiledWaterAmountServiceImpl() }
    }
}

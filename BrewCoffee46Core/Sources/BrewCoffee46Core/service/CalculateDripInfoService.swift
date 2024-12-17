import Factory

/// # Interface to calculate drip info (= water amount & drip time) service
///
/// In the '4:6 method', which is one of the brewing coffee methods, invented by Tetsu Kasuya,
/// the boiled water amount for each step must be calculated only the coffee beans weight.
/// This interface is a representation of the calculation of water amount & drip timing.
public protocol CalculateDripInfoService: Sendable {
    func calculate(_ config: Config) -> DripInfo
}

// Implementation
public final class CalculateDripInfoServiceImpl: CalculateDripInfoService {
    private let calculateWaterAmountService = Container.shared.calculateWaterAmountService()

    public func calculate(_ config: Config) -> DripInfo {
        let waterAmount = calculateWaterAmountService.calculate(config)
        let timeSecPerDripExceptFirst: Double =
            (config.totalTimeSec - config.steamingTimeSec)
            / Double((waterAmount.sixtyPercent.toArray().count + (config.firstWaterPercent < 1 ? 1 : 0)))

        var dripTimings: [DripTiming] = []
        var accValue = 0.0
        var accDripAt = 0.0
        for (index, element) in waterAmount.toArray().enumerated() {
            dripTimings.append(
                DripTiming(
                    waterAmount: accValue + element,
                    dripAt: accDripAt
                )
            )
            accValue += element
            accDripAt += index == 0 ? config.steamingTimeSec : timeSecPerDripExceptFirst
        }

        return DripInfo(dripTimings: dripTimings, waterAmount: waterAmount, totalTimeSec: config.totalTimeSec)
    }
}

extension Container {
    public var calculateDripInfoService: Factory<CalculateDripInfoService> {
        Factory(self) { CalculateDripInfoServiceImpl() }
    }
}

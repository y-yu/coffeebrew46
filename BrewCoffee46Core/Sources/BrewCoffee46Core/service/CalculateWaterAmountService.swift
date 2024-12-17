import Factory

/// ### This interface is a representation of the calculation of water amount.
public protocol CalculateWaterAmountService: Sendable {
    func calculate(_ config: Config) -> WaterAmount
}

public final class CalculateWaterAmountServiceImpl: CalculateWaterAmountService {
    public func calculate(_ config: Config) -> WaterAmount {
        let fortyPercent = (
            config.fortyPercentWaterAmount() * config.firstWaterPercent,
            config.fortyPercentWaterAmount() * (1 - config.firstWaterPercent)
        )
        let sixtyAmount = config.totalWaterAmount() * 0.6
        var sixtyPercent = NonEmptyArray(
            sixtyAmount / Double(config.partitionsCountOf6),
            []
        )
        for _ in 0..<UInt(config.partitionsCountOf6 - 1) {
            sixtyPercent.append(sixtyAmount / Double(config.partitionsCountOf6))
        }

        return WaterAmount(fortyPercent: fortyPercent, sixtyPercent: sixtyPercent)
    }
}

extension Container {
    public var calculateWaterAmountService: Factory<CalculateWaterAmountService> {
        Factory(self) { CalculateWaterAmountServiceImpl() }
    }
}

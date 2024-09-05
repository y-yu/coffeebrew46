public enum DripPhaseType: Equatable {
    case beforeDrip
    /// Current index of all drips, starts with 1.
    case dripping(Int)
    case afterDrip
}

public struct DripPhase {
    public let dripPhaseType: DripPhaseType
    public let totalNumberOfDrip: Int

    public init(dripPhaseType: DripPhaseType, totalNumberOfDrip: Int) {
        self.dripPhaseType = dripPhaseType
        self.totalNumberOfDrip = totalNumberOfDrip
    }
}

extension DripPhase {
    public func didStart() -> Bool {
        return dripPhaseType != .beforeDrip
    }

    /// - Returns
    ///     - 0: which means before dripping.
    ///     - 0 < n < `totalNumberOfDrip`: which means dripping.
    ///     - =`totalNumberOfDrip`: which means after dripping.
    public func toInt() -> Int {
        switch dripPhaseType {
        case .beforeDrip: 0
        case .dripping(let value): value - 1
        case .afterDrip: totalNumberOfDrip
        }
    }
}

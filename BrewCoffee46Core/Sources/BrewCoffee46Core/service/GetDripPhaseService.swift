import Factory

/// # Get the Nth phase in the `progressTime`.
public protocol GetDripPhaseService {
    func get(
        dripInfo: DripInfo,
        progressTime: Double
    ) -> DripPhase
}

public class GetDripPhaseServiceImpl: GetDripPhaseService {
    public func get(dripInfo: DripInfo, progressTime: Double) -> DripPhase {
        let totalNumberOfDrip = dripInfo.dripTimings.count

        if progressTime < 0 {
            return DripPhase(
                dripPhaseType: .beforeDrip,
                totalNumberOfDrip: totalNumberOfDrip
            )
        }

        if let nth = dripInfo.dripTimings.firstIndex(where: { e in
            e.dripAt > progressTime
        }) {
            return DripPhase(
                dripPhaseType: .dripping(nth),
                totalNumberOfDrip: totalNumberOfDrip
            )
        } else {
            if progressTime > dripInfo.totalTimeSec {
                return DripPhase(
                    dripPhaseType: .afterDrip,
                    totalNumberOfDrip: totalNumberOfDrip
                )
            } else {
                return DripPhase(
                    dripPhaseType: .dripping(totalNumberOfDrip),
                    totalNumberOfDrip: totalNumberOfDrip
                )
            }
        }
    }
}

extension Container {
    public var getDripPhaseService: Factory<GetDripPhaseService> {
        Factory(self) { GetDripPhaseServiceImpl() }
    }
}

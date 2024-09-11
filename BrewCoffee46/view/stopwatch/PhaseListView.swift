import BrewCoffee46Core
import Factory
import SwiftUI

struct Phase: Identifiable {
    var id = UUID()
    var index: Int
    var waterAmount: Double
    var dripAt: Double
}

struct PhaseListView: View {
    @Injected(\.getDripPhaseService) private var getDripPhaseService

    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    @Binding var progressTime: Double

    @State private var phaseList: [Phase] = []

    var body: some View {
        ScrollView {
            LazyVGrid(
                columns: Array(
                    repeating: .init(),
                    count: 3
                ),
                alignment: .center
            ) {
                Group {
                    Text("#")
                    Text("Water")
                    Text("Timing")
                }
                .font(Font.headline.weight(.bold))
            }
            ForEach(phaseList, id: \.id) { phase in
                let waterAmount = "\(String(format: "%.1f", phase.waterAmount))\(weightUnit)"
                LazyVGrid(
                    columns: Array(
                        repeating: .init(),
                        count: 3
                    ),
                    alignment: .center
                ) {
                    Group {
                        fontConfig(Text("\(phase.index + 1)"), phase: phase)
                        doneOnGoingScheduled(
                            phase.index,
                            done: AnyView(
                                HStack {
                                    Image(systemName: "hourglass.tophalf.filled")
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.primary)
                                    fontConfig(Text("\(waterAmount)"), phase: phase)
                                }),
                            onGoing: AnyView(
                                HStack {
                                    Image(systemName: "hourglass")
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.blue)
                                    fontConfig(Text("\(waterAmount)"), phase: phase)
                                }),
                            scheduled: AnyView(
                                HStack {
                                    Image(systemName: "hourglass.bottomhalf.filled")
                                        .scaledToFit()
                                        .frame(width: 24, height: 24)
                                        .foregroundColor(.primary)
                                    fontConfig(Text("\(waterAmount)"), phase: phase)
                                })
                        )
                        timingView(phase: phase)
                    }
                    .foregroundColor(appEnvironment.isTimerStarted ? .primary : .primary.opacity(0.5))
                }
            }
            .onChange(of: viewModel.currentConfig) { updatePhaseList() }
        }
        .onAppear { updatePhaseList() }
    }

    private func updatePhaseList() {
        var newPhaseList: [Phase] = []
        for (i, info) in viewModel.pointerInfo.dripInfo.dripTimings.enumerated() {
            newPhaseList.append(
                Phase(
                    index: i,
                    waterAmount: info.waterAmount,
                    dripAt: info.dripAt
                )
            )
        }
        phaseList = newPhaseList
    }

    private func doneOnGoingScheduled<A>(
        _ i: Int,
        done: A,
        onGoing: A,
        scheduled: A
    ) -> A {
        let phase = getDripPhaseService.get(
            dripInfo: viewModel.pointerInfo.dripInfo,
            progressTime: progressTime
        )
        switch phase.dripPhaseType {
        case .dripping(let n):
            if n - 1 == i {
                return onGoing
            } else if n >= i {
                return done
            } else {
                return scheduled
            }
        case .beforeDrip:
            return scheduled
        case .afterDrip:
            return done
        }
    }

    private func fontConfig(_ t: Text, phase: Phase) -> some View {
        t.font(
            doneOnGoingScheduled(
                phase.index, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
        )
        .foregroundColor(
            doneOnGoingScheduled(phase.index, done: .primary, onGoing: .accentColor, scheduled: .primary)
        )
    }

    private func timingView(phase: Phase) -> AnyView {
        let dripPhase = getDripPhaseService.get(
            dripInfo: viewModel.pointerInfo.dripInfo,
            progressTime: progressTime
        )

        switch dripPhase.dripPhaseType {
        case .dripping(let nth):
            if nth - 1 == phase.index {
                // in case on going
                return AnyView(
                    Image(systemName: "drop.fill")
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.blue)
                )
            } else if nth == phase.index {
                // in case next
                return AnyView(
                    Text(String(format: "%.1f", progressTime - phase.dripAt))
                        .font(Font(UIFont.monospacedSystemFont(ofSize: 16, weight: .light)))
                        .frame(height: 24)
                )
            } else if nth > phase.index {
                // in case done
                return AnyView(
                    Image(systemName: "checkmark.circle.fill")
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.green)
                )
            } else {
                // in scheduled
                return AnyView(
                    Image(systemName: "checkmark")
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(.gray)
                )
            }
        case .beforeDrip:
            // in scheduled
            return AnyView(
                Image(systemName: "checkmark")
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.gray)
            )
        case .afterDrip:
            // in case done
            return AnyView(
                Image(systemName: "checkmark.circle.fill")
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(.green)
            )
        }
    }
}

#if DEBUG
    struct PhaseListView_Preview: PreviewProvider {
        @ObservedObject static var viewModel: CurrentConfigViewModel = CurrentConfigViewModel()
        @State static var progressTime: Double = 90

        static var previews: some View {
            PhaseListView(progressTime: $progressTime)
                .environmentObject(AppEnvironment.init())
                .environmentObject(viewModel)
        }
    }
#endif

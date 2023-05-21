import SwiftUI

struct Phase: Identifiable {
    var id = UUID()
    var index: Int
    var waterAmount: Double
    var dripAt: Double
}

struct PhaseListView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    @Binding var progressTime: Int
    @State private var selection: Int?
    
    var body: some View {
        let phaseList = viewModel.pointerInfoViewModels.pointerInfo.enumerated().map { infoWithIndex in
            let (index, info) = infoWithIndex
            
            return Phase(
                index: index,
                waterAmount: info.value,
                dripAt: info.dripAt
            )
        }

        return ScrollView {
            GeometryReader { (geometry: GeometryProxy) in
                Grid(alignment: .bottom, horizontalSpacing: 40, verticalSpacing: 5) {
                    GridRow {
                        Text("#")
                        Text("Water")
                        Text("Timing")
                    }
                    .font(Font.headline.weight(.bold))
                    ForEach(phaseList, id: \.id) { phase in
                        let waterAmount = "\(String(format: "%.0f", phase.waterAmount))g"
                        GridRow {
                            fontConfig(Text("\(phase.index + 1)"), phase: phase)
                            fontConfig(
                                Text(
                                    doneOnGoingScheduled(
                                        phase.index,
                                        done: "Done: \(waterAmount)",
                                        onGoing: "Dripping: \(waterAmount)",
                                        scheduled: "Scheduled: \(waterAmount)"
                                    )
                                ),
                                phase: phase
                            )
                            timingView(phase: phase)
                        }
                        .foregroundColor(appEnvironment.isTimerStarted ? .primary : .primary.opacity(0.5))
                    }
                }
                .frame(width: geometry.size.width)
            }
        }
    }
    
    private func doneOnGoingScheduled<A>(
        _ i: Int,
        done: A,
        onGoing: A,
        scheduled: A
    ) -> A {
        let phase = viewModel.getNthPhase(progressTime: Double(progressTime))
        
        if (phase == i && appEnvironment.isTimerStarted) {
            return onGoing
        } else if (phase > i) {
            return done
        } else {
            return scheduled
        }
    }

    private func fontConfig(_ t: Text, phase: Phase) -> some View {
        t.font(
            doneOnGoingScheduled(phase.index, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
        )
        .foregroundColor(
            doneOnGoingScheduled(phase.index, done: .primary, onGoing: .accentColor, scheduled: .primary)
        )
    }
    
    private func timingView(phase: Phase) -> AnyView {
        let nth = viewModel.getNthPhase(progressTime: Double(progressTime))
        
        if ((nth == phase.index || nth + 1 == phase.index) && appEnvironment.isTimerStarted) {
            // in case on going or next
            return AnyView(
                fontConfig(
                    Text(String(format: "%.0f", Double(progressTime) - phase.dripAt)),
                    phase: phase
                )
            )
        } else if (nth > phase.index) {
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
    }
}

struct PhaseListView_Preview: PreviewProvider {
    @ObservedObject static var viewModel: CurrentConfigViewModel = CurrentConfigViewModel(
        validateInputService: ValidateInputServiceImpl(),
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
    )
    @State static var progressTime = 55
    
    static var previews: some View {
        PhaseListView(progressTime: $progressTime)
            .environmentObject(AppEnvironment.init())
            .environmentObject(viewModel)
    }
}

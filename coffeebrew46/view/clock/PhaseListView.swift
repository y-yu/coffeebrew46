import SwiftUI

struct PhaseList: Identifiable {
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
        let phaseList = viewModel.pointerInfoViewModels.pointerInfo.enumerated().map( { infoWithIndex in
            let (index, info) = infoWithIndex
            
            return PhaseList(
                index: index,
                waterAmount: info.value,
                dripAt: info.dripAt
            )
        })

        return ScrollView {
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
                        Text("\(phase.index + 1)")
                            .font(
                                doneOnGoingScheduled(phase.index, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                            )
                            .foregroundColor(
                                doneOnGoingScheduled(phase.index, done: .primary, onGoing: .accentColor, scheduled: .primary)
                            )
                        Text(
                            doneOnGoingScheduled(phase.index, done: "Done: \(waterAmount)", onGoing: "Dripping: \(waterAmount)", scheduled: "Scheduled: \(waterAmount)")
                        )
                        .font(
                            doneOnGoingScheduled(phase.index, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                        )
                        .foregroundColor(
                            doneOnGoingScheduled(phase.index, done: .primary, onGoing: .accentColor, scheduled: .primary)
                        )
                        Text(
                            doneOnGoingScheduled(
                                phase.index,
                                done: String(format: "+%.0f", Double(progressTime) - phase.dripAt),
                                onGoing: String(format: "%.0f", Double(progressTime) - phase.dripAt),
                                scheduled: String(format: "%.0f", Double(progressTime) - phase.dripAt)
                            ) + " sec"
                        )
                        .font(
                            doneOnGoingScheduled(phase.index, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                        )
                        .foregroundColor(
                            doneOnGoingScheduled(phase.index, done: .primary, onGoing: .accentColor, scheduled: .primary)
                        )
                        Image(
                            systemName: doneOnGoingScheduled(phase.index, done: "checkmark.circle.fill", onGoing: "drop.fill", scheduled: "checkmark")
                        )
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundColor(
                            doneOnGoingScheduled(phase.index, done: .green, onGoing: .accentColor, scheduled: .gray)
                        )
                    }
                    .foregroundColor(appEnvironment.isTimerStarted ? .primary : .primary.opacity(0.5))
                }
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

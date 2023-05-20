import SwiftUI

struct PhaseListView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    var degree: Double
    
    @State private var selection: Int?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(0..<viewModel.pointerInfoViewModels.pointerInfo.count, id: \.self) { i in
                let waterAmount = "\(String(format: "%.0f", viewModel.pointerInfoViewModels.pointerInfo[i].value))g"
                HStack {
                    Text("#\(i + 1)")
                        .font(
                            doneOnGoingScheduled(i, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                        )
                        .foregroundColor(
                            doneOnGoingScheduled(i, done: .primary, onGoing: .accentColor, scheduled: .primary)
                        )
                    Text(
                        doneOnGoingScheduled(i, done: "Done: \(waterAmount)", onGoing: "Dripping: \(waterAmount)", scheduled: "Scheduled: \(waterAmount)")
                    )
                    .font(
                        doneOnGoingScheduled(i, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                    )
                    .foregroundColor(
                        doneOnGoingScheduled(i, done: .primary, onGoing: .accentColor, scheduled: .primary)
                    )
                    Spacer()
                    Image(
                        systemName: doneOnGoingScheduled(i, done: "checkmark.circle.fill", onGoing: "drop.fill", scheduled: "checkmark")
                    )
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(
                        doneOnGoingScheduled(i, done: .green, onGoing: .accentColor, scheduled: .gray)
                    )
                }
                .foregroundColor(appEnvironment.isTimerStarted ? .primary : .primary.opacity(0.5))
            }
        }
        .listStyle(PlainListStyle())
    }
    
    private func doneOnGoingScheduled<A>(
        _ i: Int,
        done: A,
        onGoing: A,
        scheduled: A
    ) -> A {
        let phase = viewModel.pointerInfoViewModels.getNthPhase(degree: degree)
        
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
        PhaseListView(
            degree: 120
        )
        .environmentObject(AppEnvironment.init())
        .environmentObject(viewModel)
    }
}

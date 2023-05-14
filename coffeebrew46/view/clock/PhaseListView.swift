import SwiftUI

struct PhaseListView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    
    var pointerInfoViewModels: PointerInfoViewModels
    var degree: Double
    
    @State private var selection: Int?
    
    var body: some View {
        List(selection: $selection) {
            ForEach(0..<self.pointerInfoViewModels.pointerInfo.count, id: \.self) { i in
                let waterAmount = "\(String(format: "%.0f", self.pointerInfoViewModels.pointerInfo[i].value))g"
                HStack {
                    Text("#\(i + 1)")
                        .font(
                            doneOnGoingScheduled(i, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                        )
                    Text(
                        doneOnGoingScheduled(i, done: "Done: \(waterAmount)", onGoing: "On going: \(waterAmount)", scheduled: "Scheduled: \(waterAmount)")
                    )
                    .font(
                        doneOnGoingScheduled(i, done: Font.headline.weight(.light), onGoing: Font.headline.weight(.bold), scheduled: Font.headline.weight(.light))
                    )
                    Spacer()
                    Image(
                        systemName: doneOnGoingScheduled(i, done: "checkmark.circle.fill", onGoing: "drop.fill", scheduled: "checkmark")
                    )
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(
                        doneOnGoingScheduled(i, done: .green, onGoing: .blue, scheduled: .gray)
                    )
                }
                .foregroundColor(appEnvironment.isTimerStarted ? .black : .gray)
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
        let phase = getNthPhase()
        
        if (phase == i) {
            return onGoing
        } else if (phase > i) {
            return done
        } else {
            return scheduled
        }
    }
    
    private func getNthPhase() -> Int {
        if let nth = self.pointerInfoViewModels.pointerInfo.firstIndex(where: { e in
            e.degree >= degree
        }) {
            return nth - 1
        } else {
            if (degree >= 360) {
                return self.pointerInfoViewModels.pointerInfo.count
            } else {
                return self.pointerInfoViewModels.pointerInfo.count - 1
            }
        }
    }
}

struct PhaseListView_Preview: PreviewProvider {
    @State static var progressTime = 55
    @State static var pointerInfoViewModels = PointerInfoViewModels
        .withColorAndDegrees(
            (0.0, 0.0),
            (120, 72.0),
            (180, 144.0),
            (240, 216.0),
            (300, 288.0)
        )
    
    static var previews: some View {
        PhaseListView(
            pointerInfoViewModels: pointerInfoViewModels,
            degree: 120
        )
        .environmentObject(AppEnvironment.init())
    }
}

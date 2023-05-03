import SwiftUI

struct StopwatchView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel

    @State private var progressTime = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            ClockView(
                scaleMax: $viewModel.totalWaterAmount,
                pointerInfoViewModels: $viewModel.pointerInfoViewModels,
                progressTime: $progressTime,
                steamingTime: viewModel.steamingTime,
                totalTime: viewModel.totalTime
            )
            HStack {
                Spacer()
                Text("Start")
                    .font(.system(size: 20))
                    .padding()
                    .background(
                        Rectangle()
                            .stroke(lineWidth: 4)
                            .padding(6)
                    )
                    .onTapGesture {
                        if (self.timer == nil) {
                            self.appEnvironment.isTimerStarted = true
                            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                                progressTime += 1
                            }
                        }
                    }
                Spacer()
                Text("\(String(format: "%d", progressTime))")
                    .font(.system(size: 40))
                    .fixedSize()
                    .frame(width: 100, height: 40)
                Text(" sec")
                Spacer()
                Text("Stop")
                    .font(.system(size: 20))
                    .padding()
                    .background(
                        Rectangle()
                            .stroke(lineWidth: 4)
                            .padding(6)
                    )
                    .onTapGesture {
                        if let t = self.timer {
                            t.invalidate()
                            self.appEnvironment.isTimerStarted = false
                            progressTime = 0
                            self.timer = .none
                        }
                    }
                Spacer()
            }
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
        .navigationTitle("Stopwatch")
        .navigation(path: $appEnvironment.stopwatchPath)
    }
}

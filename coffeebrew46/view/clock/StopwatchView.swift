import SwiftUI

struct StopwatchView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    @Environment(\.scenePhase) private var scenePhase

    @State private var startTime: Date? {
        didSet {
            saveStartTime()
        }
    }
    @State private var progressTime = 0
    @State private var timer: Timer?

    private let buttonBackground: some View =
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(lineWidth: 1)
            .padding(6)

    var body: some View {
        VStack {
            Group {
                ClockView(
                    scaleMax: viewModel.currentConfig.totalWaterAmount(),
                    progressTime: $progressTime,
                    steamingTime: viewModel.currentConfig.steamingTimeSec,
                    totalTime: viewModel.currentConfig.totalTimeSec
                )
            }
            Divider()
            HStack(alignment: .firstTextBaseline) {
                Spacer()
                Button(action: { startTimer() }) {
                    Text("Start")
                        .font(.system(size: 20))
                        .padding()
                        .background(buttonBackground)
                }
                Spacer()
                Text("\(String(format: "%d", progressTime))")
                    .font(.system(size: 40).weight(.light))
                    .fixedSize()
                    .frame(width: 100, height: 40)
                    .foregroundColor(
                        progressTime < Int(viewModel.currentConfig.totalTimeSec) ? .black : .red
                    )
                Text("/ \(String(format: "%.0f", viewModel.currentConfig.totalTimeSec))")
                Text(" sec")
                Spacer()
                Button(action: { stopTimer() }) {
                    Text("Stop")
                        .font(.system(size: 20))
                        .padding()
                        .background(buttonBackground)
                }
                Spacer()
            }
            Spacer()
        }
        .navigationTitle("Stopwatch")
        .navigation(path: $appEnvironment.stopwatchPath)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                restoreTimer()
            }
        }
    }
    
    private func startTimer() {
        if (self.timer == nil) {
            self.appEnvironment.isTimerStarted = true
            if (self.startTime == nil) {
                self.startTime = Date()
            }
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { _ in
                if let time = startTime {
                    let now = Date()
                    progressTime = Int(now.timeIntervalSince(time))
                }
            }
        }
    }
    
    private func saveStartTime() {
        if let time = startTime {
            UserDefaults.standard.set(time, forKey: "startTime")
        } else {
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }
    
    private func stopTimer() {
        if let t = self.timer {
            t.invalidate()
            self.appEnvironment.isTimerStarted = false
            progressTime = 0
            self.timer = .none
            self.startTime = .none
        }
    }
    
    private func restoreTimer() {
        if let time = fetchStartTime() {
            startTime = time
            startTimer()
        }
    }

    private func fetchStartTime() -> Date? {
         UserDefaults.standard.object(forKey: "startTime") as? Date
    }
}

struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
            .environmentObject(
                CurrentConfigViewModel.init(
                    validateInputService: ValidateInputServiceImpl(),
                    calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
                )
            )
            .environmentObject(AppEnvironment.init())
    }
}

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
    @State private var progressTime: Double = 0
    @State private var timer: Timer?

    private let buttonBackground: some View =
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(lineWidth: 1)
            .padding(6)

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                GeometryReader { (geometry: GeometryProxy) in
                    ClockView(
                        progressTime: $progressTime,
                        steamingTime: viewModel.currentConfig.steamingTimeSec,
                        totalTime: viewModel.currentConfig.totalTimeSec
                    )
                }
                GeometryReader { (geometry: GeometryProxy) in
                    VStack {
                        PhaseListView(progressTime: $progressTime)
                            .frame(height: geometry.size.height * 0.80)
                        Divider()
                        timerController
                    }
                }
            }
            .frame(minWidth: appEnvironment.minWidth)
            
            GeometryReader { (geometry: GeometryProxy) in
                VStack {
                    Group {
                        ClockView(
                            progressTime: $progressTime,
                            steamingTime: viewModel.currentConfig.steamingTimeSec,
                            totalTime: viewModel.currentConfig.totalTimeSec
                        )
                        .frame(height: geometry.size.width * 0.95)
                    }
                    Divider()
                    PhaseListView(progressTime: $progressTime)
                    Divider()
                    timerController
                }
            }
        }
        .navigationTitle("Stopwatch")
        .navigation(path: $appEnvironment.stopwatchPath)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                restoreTimer()
            }
        }
    }
    
    private var timerController: some View {
        HStack(alignment: .firstTextBaseline) {
            Button(action: { startTimer() }) {
                Text("Start")
                    .font(.system(size: 20))
                    .padding()
                    .background(buttonBackground)
            }
            Spacer()
            Text("\(String(format: "%.1f", progressTime))")
                .font(Font(UIFont.monospacedSystemFont(ofSize: 38, weight: .light)))
                .fixedSize()
                .frame(width: 100, height: 40)
                .foregroundColor(
                    progressTime < viewModel.currentConfig.totalTimeSec ? .primary : .red
                )
            Text("/ ")
            Text(String(format: "%.0f", viewModel.currentConfig.totalTimeSec))
                .font(Font(UIFont.monospacedSystemFont(ofSize: 16, weight: .light)))
            Text(" sec")
            Spacer()
            Button(action: { stopTimer() }) {
                Text("Stop")
                    .font(.system(size: 20))
                    .padding()
                    .background(buttonBackground)
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
                    progressTime = now.timeIntervalSince(time)
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

#if DEBUG
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
#endif

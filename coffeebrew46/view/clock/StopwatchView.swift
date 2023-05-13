import SwiftUI

struct StopwatchView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    @State private var startTime: Date? {
        didSet {
            saveStartTime()
        }
    }
    @State private var progressTime = 0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Spacer()
            Spacer()
            ClockView(
                scaleMax: viewModel.currentConfig.totalWaterAmount(),
                pointerInfoViewModels: $viewModel.pointerInfoViewModels,
                progressTime: $progressTime,
                steamingTime: viewModel.currentConfig.steamingTimeSec,
                totalTime: viewModel.currentConfig.totalTimeSec
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
                        startTimer()
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
                        stopTimer()
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
        .onAppear {
            if let time = fetchStartTime() {
                startTime = time
                startTimer()
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
            print("save")
            UserDefaults.standard.set(time, forKey: "startTime")
        } else {
            print("removed")
            UserDefaults.standard.removeObject(forKey: "startTime")
        }
    }
    
    private func fetchStartTime() -> Date? {
         UserDefaults.standard.object(forKey: "startTime") as? Date
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
}

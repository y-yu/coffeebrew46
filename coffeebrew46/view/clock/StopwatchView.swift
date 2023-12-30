import SwiftUI
import AudioToolbox

struct StopwatchView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    @Environment(\.scenePhase) private var scenePhase

    @State private var startTime: Date? {
        didSet {
            saveStartTime()
        }
    }
    @State private var progressTime: Double = -3
    @State private var timer: Timer?
    @State private var hasRingingIndex: Int = 0
    @State private var isStop︎AlertPresented: Bool = false
    
    private let soundIdRing = SystemSoundID(1013)

    private let buttonBackground: some View =
        RoundedRectangle(cornerRadius: 10, style: .continuous)
            .stroke(lineWidth: 1)
            .padding(6)

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                ZStack {
                    GeometryReader { (geometry: GeometryProxy) in
                        ClockView(
                            progressTime: $progressTime,
                            steamingTime: viewModel.currentConfig.steamingTimeSec,
                            totalTime: viewModel.currentConfig.totalTimeSec
                        )
                    }
                    stopWatchCountShow
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
                        ZStack(alignment: .center) {
                            ClockView(
                                progressTime: $progressTime,
                                steamingTime: viewModel.currentConfig.steamingTimeSec,
                                totalTime: viewModel.currentConfig.totalTimeSec
                            )
                            .frame(height: geometry.size.width * 0.95)
                            stopWatchCountShow
                        }
                    }
                    Divider()
                    PhaseListView(progressTime: $progressTime)
                    Divider()
                    timerController
                }
            }
        }
        .navigationTitle("navigation title stopwatch")
        .navigation(path: $appEnvironment.stopwatchPath)
        .onChange(of: scenePhase) { phase in
            if phase == .active {
                restoreTimer()
            }
        }
    }
    
    private var stopWatchCountShow: some View {
        VStack(alignment: .center) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Spacer()
                Spacer()
                Text(String(format: "%03d", Int(floor(progressTime))))
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 38, weight: .light)))
                    .fixedSize()
                    .foregroundColor(
                        progressTime < viewModel.currentConfig.totalTimeSec ? .primary : .red
                    )
                Spacer()
                // To show the decimal part of `progressTime`
                Text(String(format: "%02d", Int((progressTime - floor(progressTime)) * 100)))
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 38, weight: .light)))
                    .fixedSize()
                    .foregroundColor(
                        progressTime < viewModel.currentConfig.totalTimeSec ? .primary : .red
                    )
                Spacer()
                Spacer()
                Spacer()
                Spacer()
            }
            Text(String(format: "/ %3.0f sec", viewModel.currentConfig.totalTimeSec))
                .font(Font(UIFont.monospacedSystemFont(ofSize: 16, weight: .light)))
                .frame(alignment: .bottom)
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
        }
    }
    
    private var timerController: some View {
        let stopButtonText = Text("Stop")
            .font(.system(size: 20))
            .frame(maxWidth: .infinity)
            .padding()
            .background(buttonBackground)

        return VStack {
            if (self.timer == nil) {
                Button(action: { startTimer() }) {
                    Text("Start")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonBackground)
                }
                .foregroundColor(.green)
            } else if (progressTime <= viewModel.currentConfig.totalTimeSec) {
                Button(action: { isStop︎AlertPresented.toggle() }) {
                    stopButtonText
                }
                .foregroundColor(.red)
                .alert("stop alert title", isPresented: $isStop︎AlertPresented) {
                    Button(role: .cancel, action: { isStop︎AlertPresented.toggle() } ) {
                        Text("stop alert cancel")
                    }
                    Button(role: .destructive, action: {
                        isStop︎AlertPresented.toggle()
                        stopTimer()
                    }) {
                        Text("stop alert stop")
                    }
                } message: {
                    Text("stop alert message")
                }
            } else {
                Button(action: { stopTimer() }) {
                    stopButtonText
                }
                .foregroundColor(.red)
            }
        }
    }
    
    private func startTimer() {
        if (self.timer == nil) {
            UIApplication.shared.isIdleTimerDisabled = true
            self.appEnvironment.isTimerStarted = true
            
            self.timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true) { _ in
                if (self.startTime == nil && progressTime >= -0.01 && progressTime <= 0.01) {
                    self.startTime = Date()
                } else if (progressTime < 0) {
                    progressTime += 0.01
                } else {
                    if let time = startTime {
                        let now = Date()
                        progressTime = now.timeIntervalSince(time)
                        ringSound()
                    }
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
            UIApplication.shared.isIdleTimerDisabled = false
            progressTime = -3
            self.timer = .none
            self.startTime = .none
            hasRingingIndex = 0
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
    
    private func ringSound() {
        let nth = viewModel.getNthPhase(progressTime: progressTime)
        
        if (nth > hasRingingIndex) {
            AudioServicesPlaySystemSound(soundIdRing)
            hasRingingIndex = nth
        }
    }
}

#if DEBUG
struct StopwatchView_Previews: PreviewProvider {
    static var previews: some View {
        StopwatchView()
            .environmentObject(CurrentConfigViewModel.init())
            .environmentObject(AppEnvironment.init())
    }
}
#endif

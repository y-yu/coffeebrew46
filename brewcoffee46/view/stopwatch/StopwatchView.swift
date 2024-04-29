import AudioToolbox
import Factory
import StoreKit
import SwiftUI

struct StopwatchView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.requestReview) private var requestReview

    @State private var startTime: Date? {
        didSet {
            saveStartTime()
        }
    }

    private static let progressTimeInit: Double = -3

    @State private var progressTime: Double = progressTimeInit
    @State private var timer: Timer?
    @State private var hasRingingIndex: Int = 0
    @State private var isStop︎AlertPresented: Bool = false

    @Injected(\.requestReviewService) private var requestReviewService
    @Injected(\.notificationService) private var notificationService

    private let soundIdRing = SystemSoundID(1013)

    // `Timer.scheduledTimer` can handle 0.01 second as minimum time window but
    // if we use it the CPU usage will be 95% so `interval` is set bigger value than it.
    private let interval = 1.0 / pow(2.0, 5.0)

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
                            .frame(height: geometry.size.height * 0.7)
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
        let progressInt = if progressTime < 0 { ceil(progressTime) } else { floor(progressTime) }

        return VStack(alignment: .center) {
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            Spacer()
            HStack(alignment: .center) {
                Spacer()
                Spacer()
                Spacer()
                Text(String(format: "%03d", Int(progressInt)))
                    .font(Font(UIFont.monospacedSystemFont(ofSize: 38, weight: .light)))
                    .fixedSize()
                    .foregroundColor(
                        progressTime < viewModel.currentConfig.totalTimeSec ? .primary : .red
                    )
                Spacer()
                // To show the decimal part of `progressTime`
                Text(String(format: "%02d", Int((progressTime < 0 ? progressInt - progressTime : progressTime - progressInt) * 100)))
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
            if self.timer == nil {
                Button(action: { startTimer() }) {
                    Text("Start")
                        .font(.system(size: 20))
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(buttonBackground)
                        .onAppear {
                            requestReviewService.check().forEach { result in
                                if result {
                                    requestReview()
                                }
                            }
                        }
                }
                .foregroundColor(.green)
            } else if progressTime <= viewModel.currentConfig.totalTimeSec {
                Button(action: { isStop︎AlertPresented.toggle() }) {
                    stopButtonText
                }
                .foregroundColor(.red)
                .alert("stop alert title", isPresented: $isStop︎AlertPresented) {
                    Button(role: .cancel, action: { isStop︎AlertPresented.toggle() }) {
                        Text("stop alert cancel")
                    }
                    Button(
                        role: .destructive,
                        action: {
                            isStop︎AlertPresented.toggle()
                            stopTimer()
                        }
                    ) {
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

    private func addNotifications() async -> ResultNea<Void, CoffeeError> {
        return await withTaskGroup(of: ResultNea<Void, CoffeeError>.self) { group in
            var errors: [CoffeeError] = []

            for (i, info) in viewModel.pointerInfoViewModels.pointerInfo.dropFirst().enumerated() {
                let notifiedAt = Int(floor(info.dripAt))

                group.addTask {
                    let title =
                        if i == 0 {
                            NSLocalizedString("notification 2nd drip", comment: "")
                        } else if i == 1 {
                            NSLocalizedString("notification 3rd drip", comment: "")
                        } else {
                            "\(i + 2)" + NSLocalizedString("notification after 4th drip suffix", comment: "")
                        }

                    return await notificationService.addNotificationUsingTimer(
                        title: title,
                        body: "🫖 \(roundCentesimal(info.value))g 💧",
                        notifiedInSeconds: notifiedAt
                    )
                }

                for await result in group {
                    switch result {
                    case .failure(let error):
                        errors += error.toArray()
                    case .success():
                        ()
                    }
                }
            }

            switch await notificationService.addNotificationUsingTimer(
                title: "☕️ " + NSLocalizedString("notification drip end", comment: ""),
                body: "",
                notifiedInSeconds: Int(ceil(viewModel.currentConfig.totalTimeSec))
            ) {
            case .failure(let error):
                errors += error.toArray()
            case .success():
                ()
            }

            if errors.isEmpty {
                return .success(())
            } else {
                return .failure(NonEmptyArray(errors.first!, Array(errors.dropFirst())))
            }
        }
    }

    private func startTimer() {
        if self.timer == nil {
            UIApplication.shared.isIdleTimerDisabled = true
            self.appEnvironment.isTimerStarted = true

            self.timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { _ in
                if self.startTime == nil && progressTime >= -interval && progressTime <= interval {
                    Task {
                        await addNotifications()
                    }
                    self.startTime = Date()
                } else if progressTime < 0 {
                    progressTime += interval
                } else {
                    if let time = startTime {
                        let now = Date()
                        progressTime = now.timeIntervalSince(time)
                        ringSound()

                        // For the battery life stop `isIdleTimerDisable` after 10 seconds from `totalTimeSec`.
                        if progressTime > (viewModel.currentConfig.totalTimeSec + 10.0) && UIApplication.shared.isIdleTimerDisabled {
                            UIApplication.shared.isIdleTimerDisabled = false
                        }
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
            progressTime = StopwatchView.progressTimeInit
            self.timer = .none
            self.startTime = .none
            hasRingingIndex = 0
            notificationService.removePendingAll()
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

        if nth > hasRingingIndex && progressTime <= viewModel.currentConfig.totalTimeSec {
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

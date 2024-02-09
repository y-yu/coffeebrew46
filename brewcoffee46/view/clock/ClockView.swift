import SwiftUI

/// # A scale.
///
/// These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
struct ClockView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    private let density: Int = 40
    private let markInterval: Int = 10
    @Binding var progressTime: Double

    var steamingTime: Double
    var totalTime: Double

    var body: some View {
        ViewThatFits(in: .horizontal) {
            HStack {
                GeometryReader { (geometry: GeometryProxy) in
                    VStack {
                        Spacer()
                        Spacer()
                        mainClockView.frame(minWidth: appEnvironment.minWidth)
                        Spacer()
                        Spacer()
                    }
                }
            }
            .frame(minWidth: appEnvironment.minWidth)
            GeometryReader { (geometry: GeometryProxy) in
                mainClockView.frame(maxHeight: geometry.size.width * 0.9)
            }
        }
    }

    private var mainClockView: some View {
        ZStack {
            ForEach(0..<(self.density * 4), id: \.self) { t in
                self.tick(tick: t)
            }
            ZStack {
                GeometryReader { (geometry: GeometryProxy) in
                    ForEach((0..<viewModel.pointerInfoViewModels.pointerInfo.count), id: \.self) { i in
                        showPointer(geometry, i)
                    }
                    ArcView(
                        progressTime: $progressTime,
                        endDegrees: endDegree(),
                        size: geometry.size
                    )
                }
            }
        }
    }

    private func endDegree() -> Double {
        if progressTime < 0 {
            return (ceil(progressTime) - progressTime) * 365
        } else {
            return viewModel.toDegree(progressTime)
        }
    }

    private func showPointer(_ geometry: GeometryProxy, _ i: Int) -> some View {
        ZStack {
            PointerView(
                id: i,
                pointerInfo: viewModel.pointerInfoViewModels.pointerInfo[i],
                geometry: geometry,
                isOnGoing: viewModel.getNthPhase(progressTime: progressTime) >= i && appEnvironment.isTimerStarted
            )
        }
    }

    // Print oblique squares as divisions of a scale.
    private func tick(tick: Int) -> some View {
        let angle: Double = Double(tick) / Double(self.density * 4) * 360
        let isMark: Bool = tick % markInterval == 0
        let caption = viewModel.toProgressTime(angle)

        return VStack {
            Text(isMark ? String(format: "%.0f", round(caption)) : " ")
                .font(.system(size: 10).weight(.light))
                .fixedSize()
                .frame(width: 20)
                .foregroundColor(!appEnvironment.isTimerStarted || angle > viewModel.toDegree(progressTime) ? .primary.opacity(0.4) : .accentColor)
            Rectangle()
                .fill(Color.primary)
                .opacity(isMark ? 0.5 : 0.3)
                .frame(width: 1, height: isMark ? 40 : 40)
            Spacer()
        }
        .rotationEffect(
            Angle.degrees(angle)
        )
    }

}

#if DEBUG
    struct ScaleView_Previews: PreviewProvider {
        @ObservedObject static var appEnvironment: AppEnvironment = .init()
        @ObservedObject static var viewModel: CurrentConfigViewModel = CurrentConfigViewModel()
        @State static var progressTime: Double = 55

        static var previews: some View {
            appEnvironment.isTimerStarted = true

            return ClockView(
                progressTime: $progressTime,
                steamingTime: 50,
                totalTime: 180
            )
            .environmentObject(appEnvironment)
            .environmentObject(viewModel)
        }
    }
#endif

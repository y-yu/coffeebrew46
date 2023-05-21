import SwiftUI

/**
 # A scale.

 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct ClockView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    
    private let density: Int = 40
    private let markInterval: Int = 10
    @Binding var progressTime: Int
    
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
                mainClockView.frame(maxHeight: geometry.size.width * 0.98)
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
                        showArcAndPointer(geometry, i)
                    }
                    ArcView(
                        startDegrees: 0.0,
                        endDegrees: viewModel.endDegree(progressTime),
                        geometry: geometry,
                        fillColor: .accentColor.opacity(0.3)
                    )
                }
            }
        }
    }
    
    private func showArcAndPointer(_ geometry: GeometryProxy, _ i: Int) -> some View {
        ZStack {
            ArcView(
                startDegrees: i - 1 < 0 ? 0.0 :
                    viewModel.pointerInfoViewModels.pointerInfo[i - 1].degree,
                endDegrees: viewModel.pointerInfoViewModels.pointerInfo[i].degree,
                geometry: geometry,
                fillColor: .clear
            )
            PointerView(
                id: i,
                pointerInfo: viewModel.pointerInfoViewModels.pointerInfo[i],
                geometry: geometry,
                value: viewModel.pointerInfoViewModels.pointerInfo[i].value,
                isOnGoing: viewModel.getNthPhase(progressTime: Double(progressTime)) >= i && appEnvironment.isTimerStarted
            )
        }
    }

    // Print oblique squares as divisions of a scale.
    private func tick(tick: Int) -> some View {
        let angle: Double = Double(tick) / Double(self.density * 4) * 360
        let isMark: Bool = tick % markInterval == 0
        let caption = angle <= viewModel.pointerInfoViewModels.pointerInfo[1].degree ?
            // In this case, it's steaming.
            steamingTime * angle / viewModel.pointerInfoViewModels.pointerInfo[1].degree :
            (totalTime - steamingTime) * (angle - viewModel.pointerInfoViewModels.pointerInfo[1].degree) / (360 - viewModel.pointerInfoViewModels.pointerInfo[1].degree) + steamingTime
        
        return VStack {
            Text(isMark ? String(format: "%.0f", ceil(caption)) : " ")
                .font(.system(size: 10).weight(.light))
                .fixedSize()
                .frame(width: 20)
                .foregroundColor(!appEnvironment.isTimerStarted || angle > viewModel.endDegree(progressTime) ? .primary.opacity(0.7) : .accentColor)
            Rectangle()
                .fill(Color.primary)
                .opacity(isMark ? 0.4 : 0.2)
                .frame(width: 1, height: isMark ? 40 : 20)
            Spacer()
        }
        .rotationEffect(
            Angle.degrees(angle)
        )
    }

}

struct ScaleView_Previews: PreviewProvider {
    @ObservedObject static var appEnvironment: AppEnvironment = .init()
    @ObservedObject static var viewModel: CurrentConfigViewModel = CurrentConfigViewModel(
        validateInputService: ValidateInputServiceImpl(),
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
    )
    @State static var progressTime = 55
    
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

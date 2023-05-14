import SwiftUI

/**
 # A scale.

 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct ClockView: View {
    // Max value of the scale.
    var scaleMax: Double

    @Binding var pointerInfoViewModels: PointerInfoViewModels
    
    private let density: Int = 40
    private let markInterval: Int = 10
    
    @Binding var progressTime: Int
    
    var steamingTime: Double
    var totalTime: Double
    
    var body: some View {
        GeometryReader { (geometry: GeometryProxy) in
            VStack {
                ZStack {
                    ForEach(0..<(self.density * 4), id: \.self) { t in
                        self.tick(tick: t)
                    }
                    ZStack {
                        GeometryReader { (geometry: GeometryProxy) in
                            ForEach((0..<self.pointerInfoViewModels.pointerInfo.count), id: \.self) { i in
                                self.showArcAndPointer(geometry, i)
                            }
                            ArcView(
                                startDegrees: 0.0,
                                endDegrees: endDegree(),
                                geometry: geometry,
                                fillColor: .cyan.opacity(0.3)
                            )
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: geometry.size.width * 0.98)
                // We need `endDegree` function to call `PhaseListView` so that's the why
                // `PhaseListView` is here rather than `StopwatchView`.
                PhaseListView(
                    pointerInfoViewModels: pointerInfoViewModels,
                    degree: endDegree()
                )
                .frame(maxWidth: .infinity, maxHeight: geometry.size.width * 0.5)
            }
        }
    }
    
    private func endDegree() -> Double {
        let pt = Double(progressTime)
        if (pt <= steamingTime) {
            return pt / steamingTime * pointerInfoViewModels.pointerInfo[1].degree
        } else {
            let withoutSteamingPerOther = (Double(totalTime) - steamingTime) / Double(pointerInfoViewModels.pointerInfo.count - 1)
            
            if (pt <= withoutSteamingPerOther + steamingTime) {
                return (pt - steamingTime) / withoutSteamingPerOther * (pointerInfoViewModels.pointerInfo[2].degree - pointerInfoViewModels.pointerInfo[1].degree) + pointerInfoViewModels.pointerInfo[1].degree
            } else {
                let firstAndSecond = steamingTime + withoutSteamingPerOther
                
                return pt > totalTime ? 360.0 : ((pt - firstAndSecond) / (totalTime - firstAndSecond)) * (360.0 - pointerInfoViewModels.pointerInfo[2].degree) + pointerInfoViewModels.pointerInfo[2].degree
            }
        }
    }
    
    private func showArcAndPointer(_ geometry: GeometryProxy, _ i: Int) -> some View {
        ZStack {
            ArcView(
                startDegrees: i - 1 < 0 ? 0.0 :
                    self.pointerInfoViewModels.pointerInfo[i - 1].degree,
                endDegrees: self.pointerInfoViewModels.pointerInfo[i].degree,
                geometry: geometry,
                fillColor: .clear
            )
            PointerView(
                id: i,
                pointerInfo: self.pointerInfoViewModels.pointerInfo[i],
                geometry: geometry,
                value: self.pointerInfoViewModels.pointerInfo[i].value
            )
        }
    }
    
    // Print oblique squares as divisions of a scale.
    private func tick(tick: Int) -> some View {
        let angle: Double = Double(tick) / Double(self.density * 4) * 360
        
        let isMark: Bool = tick % markInterval == 0
        
        return VStack {
            Text(isMark ? String(format: "%.0f", scaleMax * angle / 360) : " ")
                .font(.system(size: 10))
                .fixedSize()
                .frame(width: 20)
                .foregroundColor(.gray.opacity(0.5))
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

struct CenterCircle: Shape {
    var circleRadius: CGFloat = 5
    
    func path(in rect: CGRect) -> Path {
        return Path { p in
            p.addEllipse(in: CGRect(center: rect.getCenter(), radius: circleRadius))
        }
    }
}

extension CGRect {
    func getCenter() -> CGPoint {
        CGPoint(x: midX, y: midY)
    }
    
    init(center: CGPoint, radius: CGFloat) {
        self = CGRect(
            x: center.x - radius,
            y: center.y - radius,
            width: radius * 2,
            height: radius * 2
        )
    }
}

struct ScaleView_Previews: PreviewProvider {
    @ObservedObject static var appEnvironment: AppEnvironment = .init()
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
        appEnvironment.isTimerStarted = true

        return ClockView(
            scaleMax: 210.0,
            pointerInfoViewModels: $pointerInfoViewModels,
            progressTime: $progressTime,
            steamingTime: 50,
            totalTime: 180
        )
        .environmentObject(appEnvironment)
    }
}

import SwiftUI

/**
 # A scale.

 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct ScaleView: View {
    // Max value of the scale.
    @Binding var scaleMax: Double
    
    // This is a public variable.
    @Binding var pointerInfoViewModels: PointerInfoViewModels
    
    private let density: Int = 40
    private let markInterval: Int = 10
    
    @Binding var progressTime: Int
    
    public let steamingTime: Double
    public let totalTime: Double
    
    var body: some View {
        ZStack {
            ForEach(0..<(self.density * 4)) { t in
                self.tick(tick: t)
            }
            GeometryReader { (geometry: GeometryProxy) in
                ZStack {
                    ForEach((0..<self.pointerInfoViewModels.pointerInfo.count), id: \.self) { i in
                        self.showArcAndPointer(geometry, i)
                    }
                    ArcView(
                        startDegrees: 0.0,
                        endDegrees: endDegree(),
                        color: .gray.opacity(0.0),
                        geometry: geometry,
                        fillColor: .gray.opacity(0.5)
                    )
                }
            }
            CenterCircle()
                .fill(.black)
            Color.clear
        }
    }
    
    private func endDegree() -> Double {
        let pt = Double(progressTime)
        if (pt <= steamingTime) {
            return pt / steamingTime * pointerInfoViewModels.pointerInfo[1].degrees
        } else {
            let withoutSteamingPerOther = (Double(totalTime) - steamingTime) / Double(pointerInfoViewModels.pointerInfo.count - 1)
            
            if (pt <= withoutSteamingPerOther + steamingTime) {
                return (pt - steamingTime) / withoutSteamingPerOther * (pointerInfoViewModels.pointerInfo[2].degrees - pointerInfoViewModels.pointerInfo[1].degrees) + pointerInfoViewModels.pointerInfo[1].degrees
            } else {
                let firstAndSecond = steamingTime + withoutSteamingPerOther
                
                return pt > totalTime ? 360.0 : ((pt - firstAndSecond) / (totalTime - firstAndSecond)) * (360.0 - pointerInfoViewModels.pointerInfo[2].degrees) + pointerInfoViewModels.pointerInfo[2].degrees
                
            }
        }
    }
    
    private func showArcAndPointer(_ geometry: GeometryProxy, _ i: Int) -> some View {
        ZStack {
            ArcView(
                startDegrees: i - 1 < 0 ? 0.0 :
                    self.pointerInfoViewModels.pointerInfo[i - 1].degrees,
                endDegrees: self.pointerInfoViewModels.pointerInfo[i].degrees,
                color: self.pointerInfoViewModels.pointerInfo[i].color,
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
                .foregroundColor(.gray)
            Rectangle()
                .fill(Color.primary)
                .opacity(isMark ? 2 : 0.5)
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
    @State static var scaleMax = 210.0
    @State static var progressTime = 0
    @State static var pointerInfoViewModels = PointerInfoViewModels
            .withColorAndDegrees(
                (0.0, .cyan, 0.0),
                (120, .green, 72.0),
                (180, .red, 144.0),
                (240, .blue, 216.0),
                (300, .orange, 288.0)
            )
    
    static var previews: some View {
        ScaleView(
            scaleMax: $scaleMax,
            pointerInfoViewModels: $pointerInfoViewModels,
            progressTime: $progressTime,
            steamingTime: 50,
            totalTime: 180
        )
        .frame(width: 300, height: 300)
    }
}

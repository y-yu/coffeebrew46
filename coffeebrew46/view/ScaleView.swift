import SwiftUI

/**
 # A scale.

 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct ScaleView: View {
    // Max value of the scale.
    @Binding var scaleMax: Double
    
    // This is a public variable.
    @Binding var pointerInfoViewModels: Array<PointerInfoViewModel>
    
    private let density: Int = 40
    private let markInterval: Int = 10
    
    @State private var lastChanged: Int? = .none
    
    var body: some View {
        VStack {
        ZStack {
            ForEach(0..<(self.density * 4)) { t in
                self.tick(tick: t)
            }
            GeometryReader { (geometry: GeometryProxy) in
                ForEach(0..<self.pointerInfoViewModels.count) { i in
                    PointerView(
                        id: i,
                        pointerInfo: self.$pointerInfoViewModels[i],
                        lastChanged: self.$lastChanged,
                        geometry: geometry
                    )
                }
            }
            Color.clear
            }
            Text("last changed: \(self.lastChanged.map { v in String(v) } ?? "none" )")
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
            Rectangle()
                .fill(Color.primary)
                .opacity(isMark ? 2 : 0.5)
                .frame(width: 1, height: isMark ? 40 : 20)
            Spacer()
        }
        .rotationEffect(
            Angle.degrees(angle)
        )
        .gesture(
            TapGesture(count: 1)
                .onEnded { _ in
                    if let i = self.lastChanged {
                        self.pointerInfoViewModels[i].degrees = angle
                    }
                }
        )
    }

}

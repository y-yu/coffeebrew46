import SwiftUI

/**
 # A scale.

 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct ScaleView: View {
    // This is a public variable.
    @Binding var degrees: Double
    
    private let density: Int = 40
    private let markInterval: Int = 10
    
    var body: some View {
        ZStack {
            ForEach(0..<(self.density * 4)) { t in
                self.tick(tick: t)
            }
            GeometryReader { (geometry: GeometryProxy) in
                return ZStack {
                    Pointer()
                        .stroke(Color.orange, lineWidth: 2)
                        .rotationEffect(Angle.degrees(self.degrees))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    self.degrees =
                                        self.getDegrees(
                                            geometry: geometry,
                                            point: value.location
                                        )
                                }
                                .onEnded { value in
                                    self.degrees =
                                        self.getDegrees(
                                            geometry: geometry,
                                            point: value.location
                                        )
                                }
                        )
                    
                }
                
            }
            Color.clear
            }
    }
    
    private func tick(tick: Int) -> some View {
        let angle: Double = Double(tick) / Double(self.density * 4) * 360
        
        return VStack {
            Rectangle()
                .fill(Color.primary)
                .opacity(tick % markInterval == 0 ? 2 : 0.5)
                .frame(width: 1, height: 15)
            Spacer()
        }
        .rotationEffect(
            Angle.degrees(angle)
        )
        .gesture(
            TapGesture(count: 1)
                .onEnded { _ in
                    self.degrees = angle
                }
        )
    }
    
    /**
     # Get the angle of the point.
     
     This scale would be addressed properly by the iOS.
     We have to transform the point into (0, 0) to calculate the arctan of the `point`.
     It requires to know the size of this scale. That's the why
     this fucntion need to be given the `geometry`.
     */
    private func getDegrees(
        geometry: GeometryProxy,
        point: CGPoint
    ) -> Double {
        let radius: CGFloat =
            (geometry.size.width < geometry.size.height ?
                geometry.size.width : geometry.size.height) / 2.0
        
        let a = (Double(atan((point.y - radius) / (point.x - radius)))) * 180.0 / Double.pi
        
        return point.x >= radius ? a + 90.0 : 360.0 + a - 90.0
    }
}

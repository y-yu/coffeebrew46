import SwiftUI


struct ArcView: View {
    @Binding var startDegrees: Double
    
    @Binding var endDegrees: Double
    
    internal let color: Color
    internal let geometry: GeometryProxy
    
    var body: some View {
        VStack {
            Arc(
                startDegrees: $startDegrees,
                endDegrees: $endDegrees,
                color: color,
                geometry: geometry
            )
            .fill(self.color)
            .rotationEffect(Angle.degrees(-90.0), anchor: .center)
        }
    }
}

struct Arc: Shape {
    @Binding var startDegrees: Double
    
    @Binding var endDegrees: Double
    
    internal let color: Color
    internal let geometry: GeometryProxy
    
    private let scale: Double = 0.7
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        
        return Path { p in
            p.move(to: center)
            p.addArc(
                center: center,
                radius: (geometry.size.width / 2) * CGFloat(self.scale),
                startAngle: .degrees(self.startDegrees),
                endAngle: .degrees(self.endDegrees),
                clockwise: false
            )
        }
    }
}

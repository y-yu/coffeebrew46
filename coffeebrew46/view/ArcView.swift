import SwiftUI


struct ArcView: View {
    internal let startDegrees: Double
    
    internal let endDegrees: Double
    
    internal let color: Color
    internal let geometry: GeometryProxy
    
    internal let isEnd: Bool
    
    var body: some View {
        VStack {
            Arc(
                startDegrees: startDegrees,
                endDegrees: endDegrees,
                color: color,
                geometry: geometry
            )
            .fill(self.isEnd ? .gray : .clear)
            .rotationEffect(Angle.degrees(-90.0), anchor: .center)
        }
    }
}

struct Arc: Shape {
    internal let startDegrees: Double
    
    internal let endDegrees: Double
    
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

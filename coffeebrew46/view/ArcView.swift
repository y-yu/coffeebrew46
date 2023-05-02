import SwiftUI


struct ArcView: View {
    internal let startDegrees: Double
    
    internal let endDegrees: Double
    
    internal let color: Color
    internal let geometry: GeometryProxy
    
    internal let fillColor: Color
    
    var body: some View {
        Arc(
            startDegrees: startDegrees,
            endDegrees: endDegrees,
            color: color,
            geometry: geometry
        )
            .fill(fillColor)
            .rotationEffect(Angle.degrees(-90.0), anchor: .center)
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

struct ArcView_Previews: PreviewProvider {
    static var previews: some View {
        GeometryReader { geometry in
            ArcView(
                startDegrees: 0.0,
                endDegrees: 300.0,
                color: .gray.opacity(0.0),
                geometry: geometry,
                fillColor: .gray.opacity(0.3)
            )
        }
    }
}

import SwiftUI


struct ArcView: View {
    var startDegrees: Double
    var endDegrees: Double
    var geometry: GeometryProxy
    var fillColor: Color
    var scale: Double = 0.8
    
    var body: some View {
        Arc(
            startDegrees: startDegrees,
            endDegrees: endDegrees,
            geometry: geometry,
            scale: scale
        )
        .fill(fillColor)
        .rotationEffect(Angle.degrees(-90.0), anchor: .center)
    }
}

struct Arc: Shape {
    var startDegrees: Double
    var endDegrees: Double
    var geometry: GeometryProxy
    var scale: Double
    
    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: geometry.size.width / 2, y: geometry.size.height / 2)
        let radius =
            (geometry.size.width < geometry.size.height ? geometry.size.width : geometry.size.height) / 2 * CGFloat(self.scale)
        
        
        return Path { p in
            p.move(to: center)
            p.addArc(
                center: center,
                radius: radius,
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
                geometry: geometry,
                fillColor: .accentColor.opacity(0.3),
                scale: 0.7
            )
        }
    }
}

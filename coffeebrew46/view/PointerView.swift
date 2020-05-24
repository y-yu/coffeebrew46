import SwiftUI

/**
 # A pointer of the scale.
 
 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct PointerView: View {
    internal let id: Int
    
    @Binding var pointerInfo: PointerInfoViewModel
    
    @Binding var lastChanged: Int?
    
    internal let geometry: GeometryProxy
    
    // This state is needed for anti-locking `pointerInfo.degrees`.
    // If I tried to use `pointerInfo.degrees` directlly without `internalDegrees`,
    // the pointer won't move during dragging.
    // I think it's caused by the lockinig state by iOS memory manager or
    // something else... That's the why this internal state is needed.
    //
    // This initial value is not considered well....
    // Actually it would be better that this would be set
    // the same value of `degrees` in the constructor.
    @State private var internalDegrees: Double = 0.0
    
    @State private var isDragging: Bool = false
    
    var body: some View {
        Pointer()
            .stroke(self.pointerInfo.color, lineWidth: 2)
            .rotationEffect(
                Angle.degrees(isDragging ? self.internalDegrees : self.pointerInfo.degrees )
            )
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if (!self.isDragging) {
                            self.isDragging = true
                        }
                        
                        self.internalDegrees =
                            self.getDegrees(
                                geometry: self.geometry,
                                point: value.location
                            )
                    }
                    .onEnded { value in
                        self.internalDegrees =
                            self.getDegrees(
                                geometry: self.geometry,
                                point: value.location
                            )
                        self.pointerInfo.degrees = self.internalDegrees
                        self.lastChanged = .some(self.id)
                        self.isDragging = false
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

struct Pointer: Shape {    
    var circleRadius: CGFloat = 5
    
    func path(in rect: CGRect) -> Path {
        return Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius))
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

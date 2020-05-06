import SwiftUI

struct ScaleView: View {
    @State private var center: Optional<CGPoint> = .none
    @State var point: Optional<CGPoint> = .none
    var density: Int = 30
    var markInterval: Int = 15
    @State var degrees: Double = 0
    
    func tick(at tick: Int) -> some View {
        VStack {
            Rectangle()
                .fill(Color.primary)
                .opacity(tick % markInterval == 0 ? 2 : 0.5)
                .frame(width: 1, height: 15)
            Spacer()
        }
        .rotationEffect(
            Angle.degrees(Double(tick)/Double(density * 4) * 360)
        )
    }

    func getOrigin(_ geometry: GeometryProxy) -> CGPoint {
        geometry.frame(in: CoordinateSpace.local).origin
    }
    
    var body: some View {
        ZStack {
            ForEach(0..<(self.density * 4)) { tick in
                self.tick(at: tick)
            }
            GeometryReader { (geometry: GeometryProxy) in
                return ZStack {
                    Pointer()
                        .stroke(Color.orange, lineWidth: 2)
                        .rotationEffect(
                            //Angle.degrees(10 * 360/60)
                            Angle.degrees(self.degrees + self.getDegrees(
                                self.getOrigin(geometry),
                                self.point ?? self.getOrigin(geometry)
                            ))
                        )
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    print(value.translation)
                                    self.point = value.location
                                }
                                .onEnded { value in
                                    self.degrees =  self.degrees + self.getDegrees(
                                        self.getOrigin(geometry),
                                        self.point ?? self.getOrigin(geometry)
                                    )
                                }
                        )
                    
                }
                
            }
            Color.clear
            }
    }
    
    func getDegrees(_ center: CGPoint, _ moveTo: CGPoint) -> Double {
        return Double(atan2(moveTo.y - center.y, moveTo.x - center.x)) * 180 / Double.pi
    }
}

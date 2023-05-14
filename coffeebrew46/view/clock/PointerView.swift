import SwiftUI

/**
 # A pointer of the scale.
 
 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct PointerView: View {
    var id: Int
    var pointerInfo: PointerInfoViewModel
    var geometry: GeometryProxy
    var value: Double
    @State private var isDragging: Bool = false
    
    private let offset: Double = 10
    
    var body: some View {
        ZStack {
            VStack {
                Text(String(format: "%.0fg\n(#\(id + 1))", value))
                    .font(.system(size: 20))
                    .fixedSize()
                    .frame(width: 30)
                    .rotationEffect(
                        Angle.degrees(-self.pointerInfo.degree)
                    )
                    .offset(y: -offset)
                Spacer()
                Pointer(offset: offset)
                    .stroke(lineWidth: 1)
                
            }
            .rotationEffect(
                Angle.degrees(self.pointerInfo.degree)
            )
            CenterCircle().fill(.black)
        }
    }
}

struct Pointer: Shape {    
    var circleRadius: CGFloat = 5
    
    var offset: Double
    
    func path(in rect: CGRect) -> Path {
        return Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY - (offset * 1.5)))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius - 25))
        }
    }
}

struct PointerView_Previews: PreviewProvider {
    static var pointerInfoViewModels =
        PointerInfoViewModels.withColorAndDegrees(
            (0.0, 0.0),
            (120, 72.0),
            (180, 144.0),
            (240, 216.0),
            (300, 288.0)
        )
    
    static var previews: some View {
        ZStack {
            GeometryReader { (geometry: GeometryProxy) in
                ForEach((0..<pointerInfoViewModels.pointerInfo.count), id: \.self) { i in
                    PointerView(
                        id: i,
                        pointerInfo: pointerInfoViewModels.pointerInfo[i],
                        geometry: geometry,
                        value: pointerInfoViewModels.pointerInfo[i].value
                    )
                }
            }
        }
        .frame(width: 300, height: 300)
    }
}

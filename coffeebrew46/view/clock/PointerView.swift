import SwiftUI

/**
 # A pointer of the scale.
 
 These implementation refer from: https://talk.objc.io/episodes/S01E192-analog-clock
 */
struct PointerView: View {
    var id: Int
    var pointerInfo: PointerInfoViewModel
    var geometry: GeometryProxy
    var isOnGoing: Bool
    
    private let offset: Double = 10
    
    var body: some View {
        ZStack {
            VStack {
                Text(String(format: "%.1fg", pointerInfo.value))
                    .font(.system(size: 18))
                    .foregroundColor(
                        isOnGoing ? .accentColor : .primary
                    )
                    .fixedSize()
                    .frame(width: 30)
                    .rotationEffect(
                        Angle.degrees(-self.pointerInfo.degree)
                    )
                    .offset(y: -offset)
                Spacer()
                Pointer(offset: offset)
                    .stroke(lineWidth: 1)
                    .opacity(0.5)
                    .foregroundColor(
                        isOnGoing ? .accentColor : .primary
                    )
            }
            .rotationEffect(
                Angle.degrees(self.pointerInfo.degree)
            )
            CenterCircle()
        }
    }
}

struct Pointer: Shape {    
    var circleRadius: CGFloat = 5
    
    var offset: Double
    
    func path(in rect: CGRect) -> Path {
        return Path { p in
            p.move(to: CGPoint(x: rect.midX, y: rect.minY - (offset * 1.5)))
            p.addLine(to: CGPoint(x: rect.midX, y: rect.midY - circleRadius - 95))
        }
    }
}

#if DEBUG
struct PointerView_Previews: PreviewProvider {
    @State static var progressTime: Double = 12.34
    static var pointerInfoViewModels =  PointerInfoViewModels.defaultValue()

    static var previews: some View {
        ZStack {
            GeometryReader { (geometry: GeometryProxy) in
                ForEach((0..<pointerInfoViewModels.pointerInfo.count), id: \.self) { i in
                    PointerView(
                        id: i,
                        pointerInfo: pointerInfoViewModels.pointerInfo[i],
                        geometry: geometry,
                        isOnGoing: i == 2
                    )
                }
            }
        }
        .frame(width: 300, height: 350)
    }
}
#endif

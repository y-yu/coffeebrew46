import SwiftUI

struct ArcView: View {
    @Binding var progressTime: Double

    var endDegrees: Double
    var size: CGSize
    var scale: Double = 0.8

    private func stopwatchGradient() -> LinearGradient {
        if progressTime < 0 {
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .green.opacity(0.5), location: 0.0)
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            return LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .blue.opacity(0.1), location: 0.0),
                    .init(color: .blue.opacity(0.5), location: fillColorLocation()),
                ]),
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }

    var body: some View {
        Arc(
            startDegrees: 0.0,
            endDegrees: endDegrees,
            size: size,
            scale: scale
        )
        .fill(stopwatchGradient())
        .rotationEffect(Angle.degrees(-90.0), anchor: .center)
    }

    private func fillColorLocation() -> Double {
        let value = Double(Int(progressTime) % 10) * 0.1 + ((progressTime - floor(progressTime)) * 0.1)
        if (Int(progressTime) / 10) % 2 != 0 {
            return value
        } else {
            return 1.0 - value
        }
    }
}

struct Arc: Shape {
    var startDegrees: Double
    var endDegrees: Double
    var size: CGSize
    var scale: Double

    func path(in rect: CGRect) -> Path {
        let center = CGPoint(x: size.width / 2, y: size.height / 2)
        let radius =
            (size.width < size.height ? size.width : size.height) / 2 * CGFloat(self.scale)

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
    @State static var progressTime: Double = 55

    static var previews: some View {
        GeometryReader { geometry in
            ArcView(
                progressTime: $progressTime,
                endDegrees: 300.0,
                size: geometry.size,
                scale: 0.7
            )
        }
    }
}

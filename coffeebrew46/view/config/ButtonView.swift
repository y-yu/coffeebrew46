import SwiftUI

/**
 # ButtonType
 
 `minus` requires the minimum limit of the target and `plus` requires the maximum limit of that.
 */
enum ButtonType {
    case minus(Double)
    case plus(Double)
}

extension ButtonType {
    internal func toSystemName() -> String {
        switch self {
        case .minus(_):
            return "minus.circle"
        case .plus(_):
            return "plus.circle"
        }
    }
    
    internal func toColor() -> Color {
        switch self {
        case .minus(_):
            return .red
        case .plus(_):
            return .blue
        }
    }
}

struct ButtonView: View {
    public let buttonType: ButtonType
    public let step: Double
    public let isDisabled: Bool
    @Binding var target: Double
    
    var body: some View {
        Image(systemName: buttonType.toSystemName())
            .resizable()
            .frame(width: 30, height: 30, alignment: .center)
            .onTapGesture {
                switch buttonType {
                case let .minus(min):
                    if (target > min) {
                        target -= step
                    }
                case let .plus(max):
                    if (target < max) {
                        target += step
                    }
                }
            }
            .foregroundColor(
                isDisabled ? .gray : buttonType.toColor()
            )
            .disabled(isDisabled)
            .id(!isDisabled)
    }
}

struct ButtonView_Previews: PreviewProvider {
    @State static var target: Double = 10.0
    
    static var previews: some View {
        HStack {
            ButtonView(
                buttonType: .minus(10),
                step: 0.1,
                isDisabled: true,
                target: $target
            )
            ButtonView(
                buttonType: .plus(100),
                step: 0.1,
                isDisabled: false,
                target: $target
            )
        }
    }
}

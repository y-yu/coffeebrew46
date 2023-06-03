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
            return "minus.circle.fill"
        case .plus(_):
            return "plus.circle"
        }
    }

    internal func toColor() -> (Color, Color) {
        switch self {
        case .minus(_):
            return (.white, .red)
        case .plus(_):
            return (.accentColor, .accentColor)
        }
    }
}

struct ButtonView: View {
    public let buttonType: ButtonType
    public let step: Double
    public let isDisabled: Bool
    @Binding var target: Double
    
    var body: some View {
        Button(action: {
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
        }) {
            HStack {
                Image(systemName: buttonType.toSystemName())
                    .resizable()
                    .frame(width: 30, height: 30, alignment: .center)
                    .foregroundStyle(
                        isDisabled ? .primary.opacity(0.5) : buttonType.toColor().0,
                        isDisabled ? .primary.opacity(0.2) : buttonType.toColor().1
                    )

            }
        }
        .buttonStyle(BorderlessButtonStyle())
        .disabled(isDisabled)
        .id(!isDisabled)
    }
}

#if DEBUG
struct ButtonView_Previews: PreviewProvider {
    @State static var target: Double = 10.0
    
    static var previews: some View {
        Form {
            HStack {
                ButtonView(
                    buttonType: .minus(10),
                    step: 0.1,
                    isDisabled: true,
                    target: $target
                )
                Divider()
                ButtonView(
                    buttonType: .plus(100),
                    step: 0.1,
                    isDisabled: true,
                    target: $target
                )
            }
            HStack {
                ButtonView(
                    buttonType: .minus(10),
                    step: 0.1,
                    isDisabled: false,
                    target: $target
                )
                Divider()
                ButtonView(
                    buttonType: .plus(100),
                    step: 0.1,
                    isDisabled: false,
                    target: $target
                )
            }
        }
    }
}
#endif

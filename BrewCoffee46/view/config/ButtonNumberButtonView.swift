import SwiftUI

struct ButtonNumberButtonView: View {
    public let maximum: Double
    public let minimum: Double
    public let step: Double

    @Binding var isDisable: Bool
    @Binding var target: Double

    var body: some View {
        HStack {
            Spacer()
            ButtonView(
                buttonType: .minus(minimum),
                step: 1.0,
                isDisabled: isDisable,
                target: $target
            )
            Spacer()
            Text(String(format: "%1.0f", target))
                .font(.system(size: 30))
                .foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
            Spacer()
            ButtonView(
                buttonType: .plus(maximum),
                step: step,
                isDisabled: isDisable,
                target: $target
            )
            Spacer()
        }
        .disabled(isDisable)
        .id(!isDisable)
    }
}

#if DEBUG
    struct ButtonNumberButtonView_Previews: PreviewProvider {
        @State static var target = 5.0
        @State static var isDisable = false

        static var previews: some View {
            ButtonNumberButtonView(
                maximum: 10.0,
                minimum: 0.1,
                step: 0.1,
                isDisable: $isDisable,
                target: $target
            )
        }
    }
#endif

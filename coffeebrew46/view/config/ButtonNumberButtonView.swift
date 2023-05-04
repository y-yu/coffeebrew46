import SwiftUI

struct ButtonNumberButtonView: View {
    public let maximum: Double
    public let minimum: Double
    public let step: Double
    public let isDisable: Bool
    
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

import SwiftUI

struct ButtonSliderButtonView: View {
    public let maximum: Double
    public let minimum: Double
    public let sliderStep: Double
    public let buttonStep: Double
    public let isDisable: Bool
    
    @Binding var target: Double
    
    var body: some View {
        HStack {
            Spacer()
            ButtonView(
                buttonType: .minus(minimum),
                step: buttonStep,
                isDisabled: isDisable,
                target: $target
            )
            Spacer()
            Slider(
                value: $target,
                in: minimum...maximum,
                step: sliderStep
            )
            Spacer()
            ButtonView(
                buttonType: .plus(maximum),
                step: buttonStep,
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
struct ButtonSliderView_Previews: PreviewProvider {
    @State static var target: Double = 10.0
    
    static var previews: some View {
        VStack {
            ButtonSliderButtonView(
                maximum: 100,
                minimum: 10,
                sliderStep: 0.1,
                buttonStep: 0.1,
                isDisable: false,
                target: $target
            )
            ButtonSliderButtonView(
                maximum: 100,
                minimum: 10,
                sliderStep: 0.1,
                buttonStep: 0.1,
                isDisable: true,
                target: $target
            )
        }
    }
}
#endif

import Factory
import SwiftUI

struct NumberPickerView: View {
    @State private var numbers: TupleFloat

    private let digit: Int
    private let max: Double

    @Binding private var target: Double
    @Binding private var isDisable: Bool

    static func getNumbers(_ digit: Int, _ target: Double) -> TupleFloat {
        switch TupleFloat.fromDouble(digit, target) {
        case .success(let value):
            return value
        case .failure(_):
            return TupleFloat.unsafeFromDouble(1, target)
        }
    }

    init(digit: Int, max: Double, target: Binding<Double>, isDisable: Binding<Bool>) {
        self.digit = digit
        self.max = max
        self._target = target
        self._isDisable = isDisable

        self.numbers = NumberPickerView.getNumbers(digit, target.wrappedValue)
    }

    var body: some View {
        HStack {
            Spacer()
            Group {
                Picker("NumberPicker integer", selection: $numbers.integer) {
                    ForEach(0..<Int(floor(max)), id: \.self) { i in
                        Text("\(i)")
                            .tag(i)
                            .foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
                    }
                }
                .onChange(of: numbers.integer) { _ in
                    target = numbers.toDouble()
                }
                Text(".").foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
                Picker("NumberPicker decimal", selection: $numbers.decimal) {
                    ForEach(0..<Int(pow(10.0, Double(digit))), id: \.self) { i in
                        Text("\(i)")
                            .tag(i)
                            .foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
                    }
                }
                .frame(width: 100)
                .onChange(of: numbers.decimal) { _ in
                    target = numbers.toDouble()
                }
            }
            .pickerStyle(.wheel)
            .frame(height: 100)
            .clipped()
            .disabled(isDisable)
            .onChange(of: target) { newValue in
                self.numbers = NumberPickerView.getNumbers(digit, newValue)
            }

            Text("\(weightUnit)").fixedSize()
            Spacer()
        }
    }
}

#if DEBUG
    struct NumberPickerView_Previews: PreviewProvider {
        @State static var showTips = true
        @State static var target: Double = 98.7
        @State static var isDisable: Bool = false

        static var previews: some View {
            VStack {
                Text("\(target)")
                NumberPickerView(
                    digit: 1,
                    max: 100.0,
                    target: $target,
                    isDisable: $isDisable
                )
            }
        }
    }
#endif

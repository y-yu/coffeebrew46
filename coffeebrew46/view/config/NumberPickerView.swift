import SwiftUI
import Factory

struct NumberPickerView: View {
    @State private var numbers: [Int]
    
    private let digit: Int
    private let max: Double
    
    private let maxNumbers: [Int]
    
    @Binding private var target: Double
    @Binding private var isDisable: Bool
    @Binding private var log: String
    
    private let unit: String = "g"
    
    @Injected(\.arrayNumberService) static private var arrayNumberService
    
    static func getNumbers(_ digit: Int, _ target: Double) -> [Int] {
        switch Self.arrayNumberService.fromDouble(digit: digit, from: target) {
        case .success(let ns):
            return ns.toArray()
        case .failure(_):
            // The `error` will be thrown away because we cannot access `self.log` as this is static function.
            return (0..<digit).map{ _ in 0 } // ad-hoc!
        }
    }
    
    init(digit: Int, max: Double, target: Binding<Double>, isDisable: Binding<Bool>, log: Binding<String>) {
        self.digit = digit
        self.max = max
        self._target = target
        self._log = log
        
        self.numbers = Self.getNumbers(digit, target.wrappedValue)
        
        self._isDisable = isDisable
        
        self.maxNumbers = Self.getNumbers(digit, max)
    }
    
    var body: some View {
        HStack {
            Spacer()
            ForEach(numbers.indices, id: \.self) { index in
                Picker("NumberPicker", selection: $numbers[index]) {
                    if (index == 0 || numbers[0..<index].enumerated().allSatisfy { (i, item) in
                        item >= maxNumbers[i]
                    }) {
                        ForEach(0..<maxNumbers[index], id: \.self) { i in
                            Text("\(i)")
                                .tag(i)
                                .foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
                        }
                    } else {
                        ForEach(0...9, id: \.self) { i in
                            Text("\(i)")
                                .tag(i)
                                .foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
                        }
                    }
                }
                .pickerStyle(.wheel)
                .frame(height: 100)
                .clipped()
                .onChange(of: numbers[index]) { [oldValue = numbers[index]] _ in
                    switch Self.arrayNumberService.toDoubleWithError(numbers) {
                    case .success(let value):
                        if value < max {
                            target = value
                        } else {
                            log = "Max exceeded: \(value)"
                            numbers[index] = oldValue
                        }
                    case .failure(let error):
                        log = "\(error)"
                    }
                }
                .disabled(isDisable)

                if index == (numbers.count - 2) {
                    Text(".")
                        .foregroundStyle(isDisable ? Color.primary.opacity(0.5) : Color.primary)
                }
            }
            Text("\(unit)")
            Spacer()
        }
        .onChange(of: target) { newValue in
            switch Self.arrayNumberService.fromDouble(digit: digit, from: newValue) {
            case .success(let newNumbers):
                numbers = newNumbers.toArray()
            case .failure(let error):
                log = "\(error)"
            }
        }
    }
}

#if DEBUG
struct NumberPickerView_Previews: PreviewProvider {
    @State static var showTips = true
    @State static var target: Double = 98.7
    @State static var isDisable: Bool = false
    @State static var log: String = ""
    
    static var previews: some View {
        VStack {
            NumberPickerView(
                digit: 3,
                max: 100.0,
                target: $target,
                isDisable: $isDisable,
                log: $log
            )
            Text("\(log)")
        }
    }
}
#endif

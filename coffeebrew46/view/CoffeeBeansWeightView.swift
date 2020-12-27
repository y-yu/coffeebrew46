import SwiftUI

struct CoffeeBeansWeightView : View {
    private let state: CoffeeBeansWeightState
    private let handle: (CoffeeBeansWeightInput) -> Void
    private let binding: Binding<Double>
    
    init(_state: CoffeeBeansWeightState, _handle: @escaping (CoffeeBeansWeightInput) -> Void) {
        state = _state
        handle = _handle
        
        self.binding = Binding(
            get: {
                _state.value
            },
            set: { (newValue: Double) in
                _handle(.update(newValue))
            }
        )
    }
    
    var body: some View {
        VStack {
            Text("Coffee Beans Weight: \(String(format: "%.1f", state.value))g")
            
            HStack(alignment: .top) {
                Button(action: {
                    self.handle(.decrease(1.0))
                }) {
                    Image(systemName: "minus")
                }
                
                Slider(value: self.binding, in: 0...50, step: 0.5)
                
                Button(action: {
                    self.handle(.increase(1.0))
                }) {
                    Image(systemName: "plus")
                }
            }
        }
    }
}

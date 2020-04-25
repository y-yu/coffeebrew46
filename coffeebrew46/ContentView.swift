import SwiftUI

struct ContentView: View {
    @State var weight: Double = 0.0
    private let numberFormatter = NumberFormatter()
    
    // For DI
    private let curriculateBoiledWaterAmountService: CurriculateBoiledWaterAmountService
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependecies
    // which are required to do my business logic.
    init(
        curriculateBoiledWaterAmountService: CurriculateBoiledWaterAmountService
    ) {
        self.curriculateBoiledWaterAmountService = curriculateBoiledWaterAmountService
    }
    
    var body: some View {
        // Convert the text input into an floating point number
        // and substitute it for `weight`.
        let weightProxy: Binding<String> =
            Binding<String>(
                get: { String(self.weight) },
                set: {
                    if let value = self.numberFormatter.number(from: $0) {
                        self.weight = value.doubleValue
                    }
                }
        )
        
        return VStack {
            TextField("Weight", text: weightProxy)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Coffee beans!: \(weight)g")
            Text(
                self.curriculateBoiledWaterAmountService
                    .curriculate(
                        coffeeBeansWeight: weight,
                        // This is a sloppy impletementation!!!!!!!!!!!!!!
                        // TODO: Fix it
                        firstBoiledWaterAmount: weight / 2,
                        numberOf6: 3
                    )
                    .fold(
                        ifLeft: { (coffeeError) -> String in
                            return coffeeError.message
                        },
                        ifRight: { (boiledWaterAmount) -> String in
                            return "Boiled water amounts are \(boiledWaterAmount.toString())"
                        }
                    )
            )
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            curriculateBoiledWaterAmountService: CurriculateBoiledWaterAmountServiceImpl()
        )
    }
}

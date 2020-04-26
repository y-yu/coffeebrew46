import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            TextField("Weight", text: $viewModel.textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            Text("Coffee beans!: \(String(format: "%.1f", viewModel.weight))g")
            Text(viewModel.boiledWaterAmountText)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                curriculateBoiledWaterAmountService: CurriculateBoiledWaterAmountServiceImpl()
            )
        )
    }
}

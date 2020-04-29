import SwiftUI

struct ContentView<
    BoiledWaterAmountPresenterImplType: BoiledWaterAmountPresenter
>: View {
    @ObservedObject var viewModel: ContentViewModel<BoiledWaterAmountPresenterImplType>
    
    var body: some View {
        VStack {
            TextField("Weight", text: $viewModel.textInput)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            // Text("Coffee beans!: \(String(format: "%.1f", viewModel.weight))g")
            viewModel.boiledWaterAmountText
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl(),
                boiledWaterAmountPresenter: BoiledWaterAmountPresenterImpl()
            )
        )
    }
}

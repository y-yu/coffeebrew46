import SwiftUI

struct ContentView<
    BoiledWaterAmountPresenterImplType: BoiledWaterAmountPresenter
>
: View {
    @ObservedObject var viewModel: ContentViewModel<BoiledWaterAmountPresenterImplType>
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                Image(systemName: "minus")
                Slider(value: $viewModel.coffeeBeansWeight, in: 0...50, step: 0.5)
                Image(systemName: "plus")
            }
            Text("Coffee Beans Weight:\(viewModel.coffeeBeansWeight,  specifier: "%.1f")g")
            //Slider(value: $viewModel.firstShotBoiledWaterAmount, in: 0...50, step: 0.1)
            ScaleView(degrees: $viewModel.scaleDegrees)
                .frame(width: 200, height: 200)
            Text("Scale degrees: \(String(format: "%.1f", viewModel.scaleDegrees))g")
            //viewModel.boiledWaterAmountText
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl(
                    validateInputService: ValidateInputServiceImpl()
                ),
                boiledWaterAmountPresenter: BoiledWaterAmountPresenterImpl()
            )
        )
    }
}

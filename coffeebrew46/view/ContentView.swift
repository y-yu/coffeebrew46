import SwiftUI

struct ContentView/*<
    BoiledWaterAmountPresenterImplType: BoiledWaterAmountPresenter
>*/
: View {
    @ObservedObject var viewModel: ContentViewModel//<BoiledWaterAmountPresenterImplType>
    // @ObservedObject var pointerInfoViewModels: PointerInfoViewModels
    
    var body: some View {
        VStack {
            Text("Coffee Beans Weight: \(String(format: "%.1f", viewModel.coffeeBeansWeight))g")
            
            HStack(alignment: .top) {
                Image(systemName: "minus")
                Slider(value: $viewModel.coffeeBeansWeight, in: 0...50, step: 0.5)
                Image(systemName: "plus")
            }
            
            HStack(alignment: .top) {
                Image(systemName: "minus")
                Slider(
                    value: $viewModel.firstBoiledWaterAmount,
                    in: 0...viewModel.firstBoiledWaterAmountMax,
                    step: 0.5
                )
                Image(systemName: "plus")
            }
            
            HStack(alignment: .top) {
                Image(systemName: "minus")
                Slider(value: $viewModel.numberOf6, in: 1...5, step: 1)
                Image(systemName: "plus")
            }
            
            ScaleView(
                scaleMax: $viewModel.totalWaterAmount,
                pointerInfoViewModels: $viewModel.pointerInfoViewModels.pointerInfo
            )
            .frame(width: 350, height: 350)
            
            ForEach(
                0 ..< viewModel.pointerInfoViewModels.pointerInfo.count,
                id: \.self
            ) { i in
                Text("Coffee beans(\(i)) wegiht: \(String(format: "%.1f", self.viewModel.totalWaterAmount * self.viewModel.pointerInfoViewModels.pointerInfo[i].degrees / 360))")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl(
                    validateInputService: ValidateInputServiceImpl()
                )
                // ,boiledWaterAmountPresenter: BoiledWaterAmountPresenterImpl()
            )
            /*
            ,pointerInfoViewModels: PointerInfoViewModels().withColorAndDegrees(
                (.green, 0.0), (.red, 0.0)
            )
 */
        )
    }
}

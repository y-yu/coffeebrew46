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
                    .onTapGesture {
                        viewModel.coffeeBeansWeight -= 0.1
                    }
                Slider(value: $viewModel.coffeeBeansWeight, in: 0...50, step: 0.5)
                Image(systemName: "plus")
                    .onTapGesture {
                        viewModel.coffeeBeansWeight += 0.1
                    }
            }
            
            Text("The first warter percent of 40%: \(String(format: "%.2f", viewModel.firstBoiledWaterPercent))")
            HStack(alignment: .top) {
                Image(systemName: "minus")
                    .onTapGesture {
                        viewModel.firstBoiledWaterPercent -= 0.05
                    }
                Slider(
                    value: $viewModel.firstBoiledWaterPercent,
                    in: 0...1,
                    step: 0.1
                )
                Image(systemName: "plus")
                    .onTapGesture {
                        viewModel.firstBoiledWaterPercent += 0.05
                    }
            }
            
            Text("The number of partitions of 60%: \(String(format: "%1.0f", viewModel.numberOf6))")
            HStack(alignment: .top) {
                Slider(value: $viewModel.numberOf6, in: 1...4, step: 1)
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
                Text("The \(i + 1)th water wegiht: \(String(format: "%.1f", self.viewModel.totalWaterAmount * self.viewModel.pointerInfoViewModels.pointerInfo[i].degrees / 360))")
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

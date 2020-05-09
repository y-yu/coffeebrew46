import SwiftUI

struct ContentView<
    BoiledWaterAmountPresenterImplType: BoiledWaterAmountPresenter
>
: View {
    @ObservedObject var viewModel: ContentViewModel<BoiledWaterAmountPresenterImplType>
    @ObservedObject var pointerInfoViewModels: PointerInfoViewModels
    
    var body: some View {
        VStack {
            Text("Scale Max: \(String(format: "%.1f", viewModel.scaleMax))g")
            HStack(alignment: .top) {
                Image(systemName: "minus")
                Slider(value: $viewModel.scaleMax, in: 0...50, step: 0.5)
                Image(systemName: "plus")
            }
            //Slider(value: $viewModel.firstShotBoiledWaterAmount, in: 0...50, step: 0.1)
            ScaleView(
                    scaleMax: $viewModel.scaleMax,
                    pointerInfoViewModels: $pointerInfoViewModels.pointerInfo
                )
                .frame(width: 400, height: 400)
            ForEach(0 ..< pointerInfoViewModels.pointerInfo.count) { i in
                Text("Coffee beans(\(i)) wegiht: \(String(format: "%.1f", self.viewModel.scaleMax * self.pointerInfoViewModels.pointerInfo[i].degrees / 360))")
            }
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
            ),
            pointerInfoViewModels: PointerInfoViewModels().withColorAndDegrees(
                (.green, 0.0), (.red, 0.0)
            )
        )
    }
}

import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel

    @State private var progressTime = 0
    @State private var timer: Timer?
    @State private var totalTime: Double = 210
    @State private var steamingTime: Double = 55

    var body: some View {
        ScrollView([.vertical]) {
            VStack {
                Text("Coffee beans weight: \(String(format: "%.1f", viewModel.coffeeBeansWeight))g")
                
                ButtonSliderView(
                    maximum: 50.0,
                    minimum: 0,
                    sliderStep: 0.5,
                    buttonStep: 0.1,
                    isDisable: timer.isDefined(),
                    target: $viewModel.coffeeBeansWeight
                )
                
                Text("The first warter percent of 40%: \(String(format: "%.2f", viewModel.firstBoiledWaterPercent))")
                
                ButtonSliderView(
                    maximum: 1.0,
                    minimum: 0,
                    sliderStep: 0.1,
                    buttonStep: 0.05,
                    isDisable: timer.isDefined(),
                    target: $viewModel.firstBoiledWaterPercent
                )
                
                Text("The number of partitions of 60%")
                HStack {
                    Spacer()
                    ButtonView(
                        buttonType: .minus(2),
                        step: 1.0,
                        isDisabled: timer.isDefined(),
                        target: $viewModel.numberOf6
                    )
                    Spacer()
                    Text(String(format: "%1.0f", viewModel.numberOf6))
                        .font(.system(size: 40))
                    Spacer()
                    ButtonView(
                        buttonType: .plus(6),
                        step: 1.0,
                        isDisabled: timer.isDefined(),
                        target: $viewModel.numberOf6
                    )
                    Spacer()
                }
                
                ScaleView(
                    scaleMax: $viewModel.totalWaterAmount,
                    pointerInfoViewModels: $viewModel.pointerInfoViewModels,
                    progressTime: $progressTime,
                    steamingTime: steamingTime,
                    totalTime: totalTime
                )
                .frame(width: 300, height: 300)
                
                HStack {
                    Spacer()
                    Text("Start")
                        .font(.system(size: 20))
                        .padding()
                        .background(
                            Rectangle()
                                .stroke(lineWidth: 4)
                                .padding(6)
                        )
                        .onTapGesture {
                            if (self.timer == nil) {
                                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                                    progressTime += 1
                                }
                            }
                        }
                    Spacer()
                    Text("\(String(format: "%d", progressTime))")
                        .font(.system(size: 40))
                        .fixedSize()
                        .frame(width: 100, height: 40)
                    Text(" sec")
                    Spacer()
                    Text("Stop")
                        .font(.system(size: 20))
                        .padding()
                        .background(
                            Rectangle()
                                .stroke(lineWidth: 4)
                                .padding(6)
                        )
                        .onTapGesture {
                            if let t = self.timer {
                                t.invalidate()
                                progressTime = 0
                                self.timer = .none
                            }
                        }
                    Spacer()
                    
                }
                VStack {
                    Text("Total time: \(String(format: "%.2f", totalTime))")
                    ButtonSliderView(
                        maximum: 300.0,
                        minimum: -1.0,
                        sliderStep: 2.0,
                        buttonStep: 1.0,
                        isDisable: timer.isDefined(),
                        target: $totalTime
                    )
                
                    Text("Steaming time: \(String(format: "%.2f", steamingTime))")
                    ButtonSliderView(
                        maximum: ((totalTime / (viewModel.numberOf6 + 2)) * 2),
                        minimum: totalTime / (viewModel.numberOf6 + 2),
                        sliderStep: 2.0,
                        buttonStep: 1.0,
                        isDisable: timer.isDefined(),
                        target: $steamingTime
                    )
                }
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
            )
        )
    }
}

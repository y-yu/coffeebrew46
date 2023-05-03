import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel
    
    var body: some View {
        VStack {
            Text("Coffee beans weight: \(String(format: "%.1f", viewModel.coffeeBeansWeight))g")
            
            ButtonSliderView(
                maximum: 50.0,
                minimum: 0,
                sliderStep: 0.5,
                buttonStep: 0.1,
                isDisable: appEnvironment.isTimerStarted,
                target: $viewModel.coffeeBeansWeight
            )
            
            Text("The first warter percent of 40%: \(String(format: "%.2f", viewModel.firstBoiledWaterPercent))")
            
            ButtonSliderView(
                maximum: 1.0,
                minimum: 0,
                sliderStep: 0.1,
                buttonStep: 0.05,
                isDisable: appEnvironment.isTimerStarted,
                target: $viewModel.firstBoiledWaterPercent
            )
            
            Text("The number of partitions of 60%")
            HStack {
                Spacer()
                ButtonView(
                    buttonType: .minus(2),
                    step: 1.0,
                    isDisabled: appEnvironment.isTimerStarted,
                    target: $viewModel.numberOf6
                )
                Spacer()
                Text(String(format: "%1.0f", viewModel.numberOf6))
                    .font(.system(size: 40))
                Spacer()
                ButtonView(
                    buttonType: .plus(6),
                    step: 1.0,
                    isDisabled: appEnvironment.isTimerStarted,
                    target: $viewModel.numberOf6
                )
                Spacer()
            }
            
            Text("Total time: \(String(format: "%.2f", viewModel.totalTime))")
            ButtonSliderView(
                maximum: 300.0,
                minimum: -1.0,
                sliderStep: 2.0,
                buttonStep: 1.0,
                isDisable: appEnvironment.isTimerStarted,
                target: $viewModel.totalTime
            )
        
            Text("Steaming time: \(String(format: "%.2f", viewModel.steamingTime))")
            ButtonSliderView(
                maximum: ((viewModel.totalTime / (viewModel.numberOf6 + 2)) * 2),
                minimum: 10,
                sliderStep: 2.0,
                buttonStep: 1.0,
                isDisable: appEnvironment.isTimerStarted,
                target: $viewModel.steamingTime
            )
        }
        .navigationTitle("Configuration")
        .navigation(path: $appEnvironment.configPath)
    }
}

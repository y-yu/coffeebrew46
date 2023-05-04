import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel
    
    private let timerStep: Double = 1.0
    
    var body: some View {
        Form {
            Section(header: Text("Weight settings")) {
                Text("Coffee beans weight: \(String(format: "%.1f", viewModel.coffeeBeansWeight))g")
                ButtonSliderButtonView(
                    maximum: 50.0,
                    minimum: 0,
                    sliderStep: 0.5,
                    buttonStep: 0.1,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.coffeeBeansWeight
                )
                
                Text("Water ratio against coffee beans weight")
                ButtonNumberButtonView(
                    maximum: 20,
                    minimum: 5,
                    step: 1.0,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.coffeeBeansWeightRatio
                )
            }
            
            Section(header: Text("4:6 settings")) {
                Text("1st water percent of former 4: \(String(format: "%.0f%", viewModel.firstBoiledWaterPercent * 100))%")
                ButtonSliderButtonView(
                    maximum: 1.0,
                    minimum: 0,
                    sliderStep: 0.1,
                    buttonStep: 0.05,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.firstBoiledWaterPercent
                )
                
                Text("The number of partitions of later 6")
                ButtonNumberButtonView(
                    maximum: 6,
                    minimum: 2,
                    step: 1.0,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.numberOf6
                )
            }
            
            Section(header: Text("Timer settings")) {
                Text("Total time: \(String(format: "%.0f", viewModel.totalTime)) sec")
                ButtonSliderButtonView(
                    maximum: 300.0,
                    // If `totalTime` would be going down less than `steamingTime` + its step,
                    // then `SliderView` will crash so this `steamingTime + timerStep` is needed to avoid crash.
                    minimum: viewModel.steamingTime + timerStep,
                    sliderStep: timerStep,
                    buttonStep: timerStep,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.totalTime
                )
                
                Text("Steaming time: \(String(format: "%.0f", viewModel.steamingTime)) sec")
                ButtonSliderButtonView(
                    // This is required to avoid crash.
                    // If the maximum is `viewModel.totalTime - timerStep` then
                    // `totalTime`'s slider range could be 300~300 and it will crash
                    // so that's the why `timerStep` double subtractions are required.
                    maximum: viewModel.totalTime - timerStep - timerStep > 1 + timerStep ? viewModel.totalTime - timerStep - timerStep : 1 + timerStep,
                    minimum: 1,
                    sliderStep: timerStep,
                    buttonStep: timerStep,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.steamingTime
                )
            }
        }
        .navigationTitle("Configuration")
        .navigation(path: $appEnvironment.configPath)
    }
}

import SwiftUI

struct ConfigView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel
    
    private let timerStep: Double = 1.0
    
    var body: some View {
        Form {
            Section(header: Text("Weight settings")) {
                Text("Coffee beans weight: \(String(format: "%.1f", viewModel.currentConfig.coffeeBeansWeight))g")
                ButtonSliderButtonView(
                    maximum: 50.0,
                    minimum: 0,
                    sliderStep: 0.5,
                    buttonStep: 0.1,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.coffeeBeansWeight
                )
                
                Text("Water ratio against coffee beans weight")
                ButtonNumberButtonView(
                    maximum: 20,
                    minimum: 5,
                    step: 1.0,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.waterToCoffeeBeansWeightRatio
                )
            }
            
            Section(header: Text("4:6 settings")) {
                Text("1st water percent of former 4: \(String(format: "%.0f%", viewModel.currentConfig.firstWaterPercent * 100))%")
                ButtonSliderButtonView(
                    maximum: 1.0,
                    minimum: 0,
                    sliderStep: 0.1,
                    buttonStep: 0.05,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.firstWaterPercent
                )
                
                Text("The number of partitions of later 6")
                ButtonNumberButtonView(
                    maximum: 6,
                    minimum: 2,
                    step: 1.0,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.partitionsCountOf6
                )
            }
            
            Section(header: Text("Timer settings")) {
                Text("Total time: \(String(format: "%.0f", viewModel.currentConfig.totalTimeSec)) sec")
                ButtonSliderButtonView(
                    maximum: 300.0,
                    // If `totalTime` would be going down less than `steamingTime` + its step,
                    // then `SliderView` will crash so this `steamingTime + timerStep` is needed to avoid crash.
                    minimum: viewModel.currentConfig.steamingTimeSec + timerStep,
                    sliderStep: timerStep,
                    buttonStep: timerStep,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.totalTimeSec
                )
                
                Text("Steaming time: \(String(format: "%.0f", viewModel.currentConfig.steamingTimeSec)) sec")
                ButtonSliderButtonView(
                    // This is required to avoid crash.
                    // If the maximum is `viewModel.totalTime - timerStep` then
                    // `totalTime`'s slider range could be 300~300 and it will crash
                    // so that's the why `timerStep` double subtractions are required.
                    maximum: viewModel.currentConfig.totalTimeSec - timerStep - timerStep > 1 + timerStep ? viewModel.currentConfig.totalTimeSec - timerStep - timerStep : 1 + timerStep,
                    minimum: 1,
                    sliderStep: timerStep,
                    buttonStep: timerStep,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.steamingTimeSec
                )
            }
        }
        .navigationTitle("Configuration")
        .navigation(path: $appEnvironment.configPath)
    }
}

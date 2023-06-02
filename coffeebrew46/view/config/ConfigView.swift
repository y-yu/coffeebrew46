import SwiftUI
import SwiftUITooltip

struct ConfigView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    
    @State var showTips: Bool = false
    private let timerStep: Double = 1.0
    
    var body: some View {
        Form {
            Toggle("config show tips", isOn: $showTips)
            Section(header: Text("config weight settings")) {
                HStack {
                    Text("config coffee beans weight")
                    Text("\(String(format: "%.1f", viewModel.currentConfig.coffeeBeansWeight))g")
                }
                ButtonSliderButtonView(
                    maximum: 50.0,
                    minimum: 0,
                    sliderStep: 0.5,
                    buttonStep: 0.1,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.coffeeBeansWeight
                )
                
                TipsView(
                    showTips,
                    content: Text("config water ratio"),
                    tips: Text("config water ratio tips")
                )
                ButtonNumberButtonView(
                    maximum: 20,
                    minimum: 5,
                    step: 1.0,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.waterToCoffeeBeansWeightRatio
                )
            }
            
            Section(header: Text("config 4:6 settings")) {
                TipsView(
                    showTips,
                    content: HStack {
                        Text("config 1st water percent")
                        Text("\(String(format: "%.0f%", viewModel.currentConfig.firstWaterPercent * 100))%")
                        
                    },
                    tips: Text("config 1st water percent tips")
                )
                ButtonSliderButtonView(
                    maximum: 1.0,
                    minimum: 0.01,
                    sliderStep: 0.05,
                    buttonStep: 0.01,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.firstWaterPercent
                )
                
                TipsView(
                    showTips,
                    content: Text("config number of partitions of later 6"),
                    tips: Text("config number of partitions of later 6 tips")
                )
                ButtonNumberButtonView(
                    maximum: 10,
                    minimum: 1,
                    step: 1.0,
                    isDisable: appEnvironment.isTimerStarted,
                    target: $viewModel.currentConfig.partitionsCountOf6
                )
            }
            
            Section(header: Text("config timer setting")) {
                HStack {
                    Text("config total time")
                    Text((String(format: "%.0f", viewModel.currentConfig.totalTimeSec)))
                    Text("config sec unit")
                }
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
                
                HStack {
                    Text("config steaming time")
                    Text(String(format: "%.0f", viewModel.currentConfig.steamingTimeSec))
                    Text("config sec unit")
                }
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
            Section(header: Text("config json")) {
                NavigationLink(value: Route.saveLoad) {
                    Text("config import export")
                }
            }
            NavigationLink(value: Route.info) {
                Text("config information")
            }
        }
        .navigationTitle("Configuration")
        .navigation(path: $appEnvironment.configPath)
    }
}

#if DEBUG
struct ConfigView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigView()
            .environment(\.locale, .init(identifier: "ja"))
            .environmentObject(
                CurrentConfigViewModel.init(
                    validateInputService: ValidateInputServiceImpl(),
                    calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
                )
            )
            .environmentObject(AppEnvironment.init())
    }
}
#endif

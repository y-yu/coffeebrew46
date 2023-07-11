import SwiftUI
import SwiftUITooltip

struct ConfigView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    
    @Environment(\.saveLoadConfigService) private var saveLoadConfigService: SaveLoadConfigService
    
    @State var showTips: Bool = false
    @State var calculateCoffeeBeansWeightFromWater: Bool = false
    @State var temporaryWaterAmount: Double = 0.0 {
        didSet {
            viewModel.currentConfig.coffeeBeansWeight = temporaryWaterAmount / viewModel.currentConfig.waterToCoffeeBeansWeightRatio
        }
    }
    @State var currentSaveLoadIndex: Int = 1
    @State var log: String = ""
    
    private let timerStep: Double = 1.0
    private let coffeeBeansWeightMax = 50.0
    private let coffeeBeansWeightMin = 1.0
    
    var body: some View {
        Form {
            Toggle("config show tips", isOn: $showTips)
            Section(header: Text("config weight settings")) {
                Toggle(isOn: $calculateCoffeeBeansWeightFromWater) {
                    TipsView(
                        showTips,
                        content: Text("config calculate coffee beans from water"),
                        tips: Text("config calculate coffee beans from water tips")
                    )
                }
                .onChange(of: calculateCoffeeBeansWeightFromWater) { newValue in
                    if (newValue) {
                        temporaryWaterAmount = viewModel.currentConfig.totalWaterAmount()
                    }
                }
                !calculateCoffeeBeansWeightFromWater ? AnyView(coffeeBeansWeightSettingView) : AnyView(waterAmountSettingView)
                VStack {
                    TipsView(
                        showTips,
                        content: HStack {
                            Text("config water ratio")
                            Text("\(String(format: "%.1f%", viewModel.currentConfig.waterToCoffeeBeansWeightRatio))")
                            
                        },
                        tips: Text("config water ratio tips")
                    )
                    ButtonSliderButtonView(
                        maximum: 20,
                        minimum: 3,
                        sliderStep: 1,
                        buttonStep: 0.1,
                        isDisable: appEnvironment.isTimerStarted,
                        target: $viewModel.currentConfig.waterToCoffeeBeansWeightRatio
                    )
                    .onChange(of: viewModel.currentConfig.waterToCoffeeBeansWeightRatio) { newValue in
                        temporaryWaterAmount = viewModel.currentConfig.totalWaterAmount()
                    }
                }
            }
            
            Section(header: Text("config 4:6 settings")) {
                VStack {
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
                }
                
                VStack {
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
            }
            
            Section(header: Text("config timer setting")) {
                VStack {
                    HStack {
                        Text("config total time")
                        Text((String(format: "%.0f", viewModel.currentConfig.totalTimeSec)))
                        Text("config sec unit")
                        Spacer()
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
                }
                
                VStack {
                    HStack {
                        Text("config steaming time")
                        Text(String(format: "%.0f", viewModel.currentConfig.steamingTimeSec))
                        Text("config sec unit")
                        Spacer()
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
            }
            Section(header: Text("config save load setting")) {
                Picker("config select save load index", selection: $currentSaveLoadIndex) {
                    ForEach(1...10, id: \.self) { index in
                        Text("\(index)").tag(index)
                    }
                }
                .fixedSize(horizontal: false, vertical: true)
                VStack {
                    Spacer()
                    HStack {
                        Button(action: {
                            loadConfig()
                        }){
                            HStack {
                                Spacer()
                                Text("config load button")
                                Spacer()
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        .disabled(appEnvironment.isTimerStarted)
                        .id(!appEnvironment.isTimerStarted)
                        
                        Divider()
                        
                        Button(action: {
                            saveConfig()
                        }){
                            HStack {
                                Spacer()
                                Text("config save button")
                                Spacer()
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                        
                        Divider()
                        
                        Button(action: {
                            saveLoadConfigService.delete(key: "\(currentSaveLoadIndex)")
                            log = NSLocalizedString("config delete success log", comment: "")
                        }){
                            HStack {
                                Spacer()
                                Text("config delete button")
                                    .foregroundColor(.red)
                                Spacer()
                            }
                        }
                        .buttonStyle(BorderlessButtonStyle())
                    }
                    .fixedSize(horizontal: false, vertical: true)

                    Divider()
                    TextEditor(text: $log)
                }
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
        .navigationTitle("navigation title configuration")
        .navigation(path: $appEnvironment.configPath)
    }
                             
    private var coffeeBeansWeightSettingView: some View {
        VStack {
            HStack {
                Text("config coffee beans weight")
                Text("\(String(format: "%.1f", viewModel.currentConfig.coffeeBeansWeight))g")
                Spacer()
            }
            ButtonSliderButtonView(
                maximum: coffeeBeansWeightMax,
                minimum: coffeeBeansWeightMin,
                sliderStep: 0.5,
                buttonStep: 0.1,
                isDisable: appEnvironment.isTimerStarted,
                target: $viewModel.currentConfig.coffeeBeansWeight
            )
        }
    }
    
    private var waterAmountSettingView: some View {
        // In order to call `didSet` of `temporaryWaterAmount`,
        // I cannot help but to define this `Binding` manually.
        // I don't know why it's required.
        let temporaryWaterAmountBinding: Binding<Double> = Binding(
            get: { self.temporaryWaterAmount },
            set: { self.temporaryWaterAmount = $0 }
        )

        return VStack {
            HStack {
                Text("config water amount")
                Text("\(String(format: "%.0f", temporaryWaterAmount))g")
                Spacer()
                Text("config coffee beans weight")
                Text("\(String(format: "%.1f", viewModel.currentConfig.coffeeBeansWeight))g")
            }
            ButtonSliderButtonView(
                maximum: coffeeBeansWeightMax * viewModel.currentConfig.waterToCoffeeBeansWeightRatio,
                minimum: coffeeBeansWeightMin * viewModel.currentConfig.waterToCoffeeBeansWeightRatio,
                sliderStep: 10,
                buttonStep: 1,
                isDisable: appEnvironment.isTimerStarted,
                target: temporaryWaterAmountBinding
            )
        }
    }
    
    private func loadConfig() {
        switch saveLoadConfigService.load(key: String(currentSaveLoadIndex)) {
        case .success(.some(let config)):
            log = NSLocalizedString("config load success log", comment: "")
            viewModel.currentConfig = config
        case .success(.none):
            log = NSLocalizedString("config load data not found log", comment: "")
        case .failure(let errors):
            log = "\(errors)"
        }
    }

    private func saveConfig() {
        switch saveLoadConfigService.save(
            config: viewModel.currentConfig,
            key: String(currentSaveLoadIndex)
        ) {
        case .success():
            log = NSLocalizedString("config save success log", comment: "")
        case .failure(let errors):
            log = "\(errors)"
        }
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

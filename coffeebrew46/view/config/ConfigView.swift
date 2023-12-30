import SwiftUI
import SwiftUITooltip
import Factory

struct ConfigView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
    
    @Injected(\.saveLoadConfigService) private var saveLoadConfigService

    @Environment(\.scenePhase) private var scenePhase
    
    @State var showTips: Bool = false
    @State var calculateCoffeeBeansWeightFromWater: Bool = false
    @State var temporaryWaterAmount: Double = 0.0 {
        didSet {
            viewModel.currentConfig.coffeeBeansWeight = temporaryWaterAmount / viewModel.currentConfig.waterToCoffeeBeansWeightRatio
        }
    }
    @State var currentSaveLoadIndex: Int = 0
    @State var log: String = ""
    
    // The elements of `savedConfigNote` indicates these 3 semantics of saved configuration:
    //   1. If the element is `.none`, it means the data is empty (not saved yet)
    //   2. If the element is `.some("")`, it means the data is saved and `note` of the data is empty string
    //   3. If the element is `.some("hoge")`, it means the data is saved and `note` of the data is not empty
    @State var savedConfigNote: Array<String?> =
        [.none, .none, .none, .none, .none, .none, .none, .none, .none, .none, .none]
    
    private let timerStep: Double = 1.0
    private let coffeeBeansWeightMax = 50.0
    private let coffeeBeansWeightMin = 1.0
    
    private let temporaryCurrentConfigKey = "temporaryCurrentConfig"

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
                    ForEach(Array(zip(savedConfigNote.indices, savedConfigNote)), id: \.0) { index, noteOpt in
                        if let note = noteOpt {
                            if note.isEmpty {
                                Text("\(index): " + NSLocalizedString("config note empty string", comment: ""))
                            } else {
                                Text("\(index): \(note)")
                            }
                        } else {
                            Text("\(index): " + NSLocalizedString("config empty", comment: ""))
                        }
                    }
                }
                .onAppear {
                    updateSavedConfigNote()
                }
                .fixedSize(horizontal: false, vertical: true)
                
                HStack {
                    let noteBinding: Binding<String> =
                        Binding(
                            get: {
                                if let note = viewModel.currentConfig.note {
                                    return note
                                } else {
                                    return ""
                                }
                            },
                            set: {
                                let newValue: String = $0
                                if newValue.isEmpty {
                                    viewModel.currentConfig.note = .none
                                } else {
                                    viewModel.currentConfig.note = .some(newValue)
                                }
                            }
                        )
                    TextField("config note placeholder", text: noteBinding)
                        .textInputAutocapitalization(.never)
                        .submitLabel(.done)
                }
                
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
                            // In order to update save & load target picker label.
                            updateSavedConfigNote()
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
                            // In order to update save & load target picker label.
                            updateSavedConfigNote()
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
                        .font(.system(size: 12, design: .monospaced).weight(.light))
                        .foregroundColor(.primary.opacity(0.5))
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
        .onChange(of: scenePhase) { phase in
            switch phase {
            case .background:
                ()
            case .inactive:
                switch scenePhase {
                case .active:
                    let _ = saveLoadConfigService.save(
                        config: viewModel.currentConfig,
                        key: temporaryCurrentConfigKey
                    )
                case .background:
                    ()
                default:
                    ()
                }
            case .active:
                switch saveLoadConfigService.load(
                    key: temporaryCurrentConfigKey
                ) {
                case .success(.some(let config)):
                    viewModel.currentConfig = config
                case .success(.none):
                    ()
                case .failure(_):
                    // Nice catch!
                    ()
                }
            @unknown default:
                ()
            }
        }
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
    
    private func updateSavedConfigNote() {
        for i in 0..<savedConfigNote.count {
            switch saveLoadConfigService.load(key: String(i)) {
            case .success(.some(let config)):
                if let note = config.note {
                    savedConfigNote[i] = .some(note)
                } else {
                    // If the loaded data was created by old app which has no feature to save note,
                    // `config.note` is `.none` but `.none` indicates that the data is not found indexed of `i`
                    // on the semantics of `savedConfigNote` so since `saveLoadConfigService.load` success to load data
                    // we have to assign an empty string to `savedConfigNote[i]`.
                    savedConfigNote[i] = .some("")
                }
            case .success(.none):
                savedConfigNote[i] = .none
            case .failure(let errors):
                log = "\(errors)"
            }
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
            .environmentObject(CurrentConfigViewModel.init())
            .environmentObject(AppEnvironment.init())
    }
}
#endif

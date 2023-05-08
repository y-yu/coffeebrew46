import SwiftUI

@main
struct MainApp: App {
    @ObservedObject var appEnvironment: AppEnvironment = .init()
    @ObservedObject var viewModel: CurrentConfigViewModel = CurrentConfigViewModel(
        validateInputService: ValidateInputServiceImpl(),
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
    )

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appEnvironment)
                .environmentObject(viewModel)
        }
    }
}

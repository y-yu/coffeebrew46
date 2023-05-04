import SwiftUI

@main
struct MainApp: App {
    @ObservedObject var appEnvironment: AppEnvironment = .init()
    @ObservedObject var viewModel: ContentViewModel = ContentViewModel(
        calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl(
            validateInputService: ValidateInputServiceImpl()
        )
    )

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(appEnvironment)
                .environmentObject(viewModel)
        }
    }
}

import SwiftUI

struct RootView: View {
    @EnvironmentObject var appEnvironment: WatchKitAppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    var body: some View {
        List {
            NavigationLink(value: Route.config) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "slider.horizontal.3")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.green)
                            .frame(width: 96, height: 40, alignment: .leading)
                        Spacer()
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Spacer()
                        Text("navigation title configuration")
                    }
                }
            }

            NavigationLink(value: Route.stopwatch) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "stopwatch")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .foregroundColor(.yellow)
                            .frame(width: 96, height: 40, alignment: .leading)
                        Spacer()
                        Image(systemName: "ellipsis.circle.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.gray)
                    }
                    HStack {
                        Spacer()
                        Text("navigation title stopwatch")
                    }
                }
            }
        }
        .navigation(path: $appEnvironment.rootPath)
        .currentConfigSaveLoadModifier($viewModel.currentConfig, $viewModel.log)
    }
}

#if DEBUG
    struct RootView_Perviews: PreviewProvider {
        static var previews: some View {
            RootView()
                .environmentObject(WatchKitAppEnvironment())
        }
    }
#endif

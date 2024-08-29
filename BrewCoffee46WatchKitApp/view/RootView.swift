import SwiftUI

struct RootView: View {
    @EnvironmentObject var appEnvironment: WatchKitAppEnvironment

    var body: some View {
        List {
            NavigationLink(value: Route.config) {
                VStack(alignment: .leading) {
                    HStack {
                        Image(systemName: "info.circle")
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
                    Text("config save load current config")
                }
            }
        }
        .navigation(path: $appEnvironment.rootPath)
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

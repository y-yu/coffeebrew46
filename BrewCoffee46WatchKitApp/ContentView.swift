import SwiftUI

struct ContentView: View {
    @EnvironmentObject var watchContentViewModel: WatchContentViewModel

    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
            Text(watchContentViewModel.config)
        }
        .padding()
    }
}

#Preview {
    ContentView()
}

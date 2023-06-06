import SwiftUI

struct InfoView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    
    var body: some View {
        Form {
            Section(header: Text("info version")) {
                Text((Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!)
            }
            Section(header: Text("info license")) {
                Link("MIT License",
                      destination: URL(string: "https://github.com/y-yu/coffeebrew46/blob/master/LICENSE")!)
            }
            
            Section(header: Text("info source code")) {
                Link("https://github.com/y-yu/coffeebrew46",
                      destination: URL(string: "https://github.com/y-yu/coffeebrew46")!)
            }
            
            Section(header: Text("info author")) {
                HStack {
                    Text("Email:")
                    Text("yyu@mental.poker")
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Twitter:")
                    Link(
                        destination: URL(string: "https://twitter.com/_yyu_")!,
                        label: { Text(verbatim: "@_yyu_") }
                    )
                }
            }
        }
        .navigationTitle("Information")
    }
}

#if DEBUG
struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .environmentObject(AppEnvironment.init())
    }
}
#endif

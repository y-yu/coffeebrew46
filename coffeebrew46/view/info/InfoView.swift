import SwiftUI

struct InfoView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    
    var body: some View {
        Form {
            Section(header: Text("License")) {
                Link("MIT License",
                      destination: URL(string: "https://github.com/y-yu/coffeebrew46/blob/master/LICENSE")!)
            }
            
            Section(header: Text("Source code")) {
                Link("https://github.com/y-yu/coffeebrew46",
                      destination: URL(string: "https://github.com/y-yu/coffeebrew46")!)
            }
            
            Section(header: Text("Author")) {
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

struct InfoView_Previews: PreviewProvider {
    static var previews: some View {
        InfoView()
            .environmentObject(AppEnvironment.init())
    }
}

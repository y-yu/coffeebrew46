import SwiftUI

struct InfoView: View {
    var body: some View {
        Form {
            Section(header: Text("info version")) {
                Text((Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String)!)
            }

            Section(header: Text("info license header")) {
                NavigationLink(value: Route.ossLicense) {
                    Text("info oss licenses")
                }
            }

            Section(header: Text("info source code")) {
                Link(
                    "https://github.com/y-yu/coffeebrew46",
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

            Section(header: Text("info references")) {
                VStack {
                    Link(
                        destination: URL(string: "https://www.amazon.co.jp/dp/4297134039")!,
                        label: { Text(verbatim: "誰でも簡単！世界一の4：6メソッドでハマる 美味しいコーヒー") }
                    )
                    HStack {
                        Spacer()
                        Text("info by kasuya tetsu")
                    }
                }
            }
        }
        .navigationTitle("navigation title information")
    }
}

#if DEBUG
    struct InfoView_Previews: PreviewProvider {
        static var previews: some View {
            InfoView()
        }
    }
#endif

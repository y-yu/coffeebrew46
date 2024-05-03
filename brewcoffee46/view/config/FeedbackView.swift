import SafariServices
import SwiftUI

struct FeedbackView: View {
    private let url = URL(string: "https://forms.gle/HxcdY6xGYMxrx2Bj6")!
    @State var didShowWebView: Bool = false

    var body: some View {
        VStack {
            Button {
                didShowWebView = true
            } label: {
                Text("config feedback link")
            }
        }
        .fullScreenCover(isPresented: $didShowWebView) {
            FeedbackFormWebView(url: url).edgesIgnoringSafeArea(.all)
        }
    }
}

struct FeedbackFormWebView: UIViewControllerRepresentable {
    let url: URL

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let safariViewController = SFSafariViewController(url: url)
        safariViewController.dismissButtonStyle = .done
        return safariViewController
    }

    public func updateUIViewController(
        _ safariViewController: SFSafariViewController,
        context: Context
    ) {}
}

#if DEBUG
    struct FeedbackView_Previews: PreviewProvider {
        static var previews: some View {
            FeedbackView()
        }
    }
#endif

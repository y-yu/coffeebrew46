import WatchConnectivity

final class WatchContentViewModel: NSObject, ObservableObject {
    @Published var config: String = ""

    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
}

extension WatchContentViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any]) {
        Task { @MainActor in
            if let value = message["config"] as? String {
                config = value
            }
        }
    }
}

import Factory
import WatchConnectivity

protocol WatchConnectionService {
    func send(
        config: Config
    )
}

class WatchConnectionServiceImpl: NSObject, WatchConnectionService {
    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }

    func send(
        config: Config
    ) {
        guard session.activationState == .activated else {
            print("Sending method can only be called while the session is active.")
            return
        }

        switch config.toJSON(isPrettyPrint: false) {
        case .success(let json):
            session.sendMessage(["config": json], replyHandler: nil) { err in
                print("error: \(err)")
            }
            print("send!")
        case .failure(_):
            ()
        }
    }
}

extension Container {
    var watchConnectionService: Factory<WatchConnectionService> {
        Factory(self) { WatchConnectionServiceImpl() }
    }
}

extension WatchConnectionServiceImpl: WCSessionDelegate {
    func sessionDidBecomeInactive(_ session: WCSession) {

    }

    func sessionDidDeactivate(_ session: WCSession) {

    }

    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {

    }

}

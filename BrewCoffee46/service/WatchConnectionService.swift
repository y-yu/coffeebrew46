import BrewCoffee46Core
import Factory
import WatchConnectivity

protocol WatchConnectionService {
    func isPaired() -> Bool

    func isReachable() -> Bool

    func send(config: Config) async -> ResultNea<Void, CoffeeError>
}

class WatchConnectionServiceImpl: NSObject, WatchConnectionService {
    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }

    func isPaired() -> Bool {
        session.isPaired
    }

    func isReachable() -> Bool {
        session.isReachable
    }

    func send(config: Config) async -> ResultNea<Void, CoffeeError> {
        await withCheckedContinuation { continuation in
            if session.activationState != .activated {
                continuation.resume(returning: .failure(NonEmptyArray(CoffeeError.watchSessionIsNotActivated)))
                return
            }

            switch config.toJSON(isPrettyPrint: false) {
            case .success(let json):
                session.sendMessage(
                    ["config": json],
                    replyHandler: { data in
                        continuation.resume(returning: .success(()))
                    },
                    errorHandler: { error in
                        continuation.resume(returning: .failure(NonEmptyArray(.sendMessageToWatchOSFailure(error))))
                    }
                )
            case .failure(let error):
                continuation.resume(returning: .failure(NonEmptyArray(CoffeeError.jsonError(error))))
            }
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

import BrewCoffee46Core
import Factory
import WatchConnectivity

final class CurrentConfigViewModel: NSObject, ObservableObject {
    @Injected(\.validateInputService) private var validateInputService: ValidateInputService
    @Injected(\.calculateDripInfoService) private var calculateDripInfoService: CalculateDripInfoService
    @Injected(\.saveLoadConfigService) private var saveLoadConfigService: SaveLoadConfigService

    @Published var currentConfig: Config = Config.defaultValue {
        didSet {
            if currentConfig != oldValue {
                switch validateInputService.validate(config: currentConfig) {
                case .success():
                    self.dripInfo = calculateDripInfoService.calculate(currentConfig)
                    saveLoadConfigService
                        .saveCurrentConfig(config: currentConfig)
                        .recoverWithErrorLog(&log)
                case .failure(let errors):
                    log = errors.getAllErrorMessage()
                    currentConfig = oldValue
                }
            }
        }
    }
    @Published var dripInfo: DripInfo = DripInfo.defaultValue
    @Published var log: String = ""

    private let session: WCSession

    init(session: WCSession = .default) {
        self.session = session
        super.init()
        self.session.delegate = self
        self.session.activate()
    }
}

extension CurrentConfigViewModel: WCSessionDelegate {
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: (any Error)?) {

    }

    func session(_ session: WCSession, didReceiveMessage message: [String: Any], replyHandler: @escaping (([String: Any]) -> Void)) {
        if let value = message["config"] as? String {
            switch Config.fromJSON(value) {
            case .success(let config):
                currentConfig = config
                replyHandler([:])
            case .failure(let errors):
                log = errors.toArray().map { $0.getMessage() }.joined(separator: "\n")
            }
        }
    }
}

import Foundation
import SwiftUI

/**
 # Save & load user's configuration.
 */
protocol SaveLoadConfigService {
    func save(config: Config, key: String) -> ResultNel<Void, CoffeeError>
    
    func load(key: String) -> ResultNel<Config?, CoffeeError>
    
    func delete(key: String) -> Void
}

class SaveLoadConfigServiceImpl: SaveLoadConfigService {
    private let keyPrefix = "saved_config"
    func save(config: Config, key: String) -> ResultNel<Void, CoffeeError> {
        return config.toJSON(isPrettyPrint: false).map { json in
            UserDefaults.standard.set(json, forKey: userDefaultsKey(key))
        }
    }
    
    func load(key: String) -> ResultNel<Config?, CoffeeError> {
        switch UserDefaults.standard.object(forKey: userDefaultsKey(key)) as? String {
        case .some(let json):
            return Config.fromJSON(json).map { config in .some(config) }
        case .none:
            return .success(.none)
        }
    }
    
    func delete(key: String) -> Void {
        UserDefaults.standard.removeObject(forKey: userDefaultsKey(key))
    }
    
    private func userDefaultsKey(_ key: String) -> String {
        "\(keyPrefix)_\(key)"
    }
}

struct SaveLoadConfigServiceKey: EnvironmentKey {
    static let defaultValue: SaveLoadConfigService = SaveLoadConfigServiceImpl()
}

extension EnvironmentValues {
    var saveLoadConfigService: SaveLoadConfigService {
        get { self[SaveLoadConfigServiceKey.self] }
        set { self[SaveLoadConfigServiceKey.self] = newValue }
    }
}

import Foundation
import Factory

/**
 # Save & load user's configuration.
 */
protocol SaveLoadConfigService {
    func save(config: Config, key: String) -> ResultNea<Void, CoffeeError>
    
    func load(key: String) -> ResultNea<Config?, CoffeeError>
    
    func delete(key: String) -> Void
}

class SaveLoadConfigServiceImpl: SaveLoadConfigService {
    @Injected(\.userDefaultsService) private var userDefaultsService
    
    func save(config: Config, key: String) -> ResultNea<Void, CoffeeError> {
        return userDefaultsService.setEncodable(config, forKey: userDefaultsKey(key))
    }
    
    func load(key: String) -> ResultNea<Config?, CoffeeError> {
        return userDefaultsService.getDecodable(forKey: userDefaultsKey(key))
    }
    
    func delete(key: String) -> Void {
        userDefaultsService.delete(forKey: userDefaultsKey(key))
    }
    
    private func userDefaultsKey(_ key: String) -> String {
        "\(SaveLoadConfigServiceImpl.keyPrefix)_\(key)"
    }
}

extension SaveLoadConfigServiceImpl {
    static internal let keyPrefix = "saved_config"
}

extension Container {
    var saveLoadConfigService: Factory<SaveLoadConfigService> {
        Factory(self) { SaveLoadConfigServiceImpl() }
    }
}

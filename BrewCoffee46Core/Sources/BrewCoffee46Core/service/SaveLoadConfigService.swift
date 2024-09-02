import Factory
import Foundation

/// # Save & load user's configuration.
public protocol SaveLoadConfigService {
    func saveCurrentConfig(config: Config) -> ResultNea<Void, CoffeeError>

    func loadCurrentConfig() -> ResultNea<Config?, CoffeeError>

    func saveAll(configs: [Config]) -> ResultNea<Void, CoffeeError>

    func loadAll() -> ResultNea<[Config]?, CoffeeError>

    func delete(key: String) -> Void
}

public class SaveLoadConfigServiceImpl: SaveLoadConfigService {
    @Injected(\.userDefaultsService) private var userDefaultsService

    public func saveCurrentConfig(config: Config) -> ResultNea<Void, CoffeeError> {
        return userDefaultsService.setEncodable(config, forKey: userDefaultsKey(SaveLoadConfigServiceImpl.temporaryCurrentConfigKey))
    }

    public func loadCurrentConfig() -> ResultNea<Config?, CoffeeError> {
        return userDefaultsService.getDecodable(forKey: userDefaultsKey(SaveLoadConfigServiceImpl.temporaryCurrentConfigKey))
    }

    public func saveAll(configs: [Config]) -> ResultNea<Void, CoffeeError> {
        return userDefaultsService.setEncodable(configs, forKey: userDefaultsKey(SaveLoadConfigServiceImpl.configsKey))
    }

    public func loadAll() -> ResultNea<[Config]?, CoffeeError> {
        return userDefaultsService.getDecodable(forKey: userDefaultsKey(SaveLoadConfigServiceImpl.configsKey))
    }

    public func delete(key: String) -> Void {
        userDefaultsService.delete(forKey: userDefaultsKey(key))
    }

    private func userDefaultsKey(_ key: String) -> String {
        "\(SaveLoadConfigServiceImpl.keyPrefix)_\(key)"
    }
}

extension SaveLoadConfigServiceImpl {
    static internal let keyPrefix = "saved_config"

    static internal let temporaryCurrentConfigKey = "temporaryCurrentConfig"

    static internal let configsKey = "configs"
}

extension Container {
    public var saveLoadConfigService: Factory<SaveLoadConfigService> {
        Factory(self) { SaveLoadConfigServiceImpl() }
    }
}
import BrewCoffee46Core
import Factory
import Foundation

/// # Save & load user's configuration.
protocol SaveLoadConfigService {
    func saveCurrentConfig(config: Config) -> ResultNea<Void, CoffeeError>

    func loadCurrentConfig() -> ResultNea<Config?, CoffeeError>

    func saveAll(configs: [Config]) -> ResultNea<Void, CoffeeError>

    func loadAll() -> ResultNea<[Config]?, CoffeeError>

    func loadAllLegacyConfigs() -> ResultNea<[Config], CoffeeError>

    func deleteAllLegacyConfigs() -> Void

    func delete(key: String) -> Void
}

class SaveLoadConfigServiceImpl: SaveLoadConfigService {
    @Injected(\.userDefaultsService) private var userDefaultsService

    func saveCurrentConfig(config: Config) -> ResultNea<Void, CoffeeError> {
        return userDefaultsService.setEncodable(config, forKey: userDefaultsKey(SaveLoadConfigServiceImpl.temporaryCurrentConfigKey))
    }

    func loadCurrentConfig() -> ResultNea<Config?, CoffeeError> {
        return userDefaultsService.getDecodable(forKey: userDefaultsKey(SaveLoadConfigServiceImpl.temporaryCurrentConfigKey))
    }

    func saveAll(configs: [Config]) -> ResultNea<Void, CoffeeError> {
        return userDefaultsService.setEncodable(configs, forKey: userDefaultsKey(SaveLoadConfigServiceImpl.configsKey))
    }

    func loadAll() -> ResultNea<[Config]?, CoffeeError> {
        return userDefaultsService.getDecodable(forKey: userDefaultsKey(SaveLoadConfigServiceImpl.configsKey))
    }

    func loadAllLegacyConfigs() -> ResultNea<[Config], CoffeeError> {
        return Array(0..<SaveLoadConfigServiceImpl.numberOfLegacySavedConfigs)
            .reduce(
                .success([]),
                { (acc: ResultNea<[Config], CoffeeError>, i: Int) -> ResultNea<[Config], CoffeeError> in
                    acc.flatMap { results in
                        userDefaultsService
                            .getDecodable(forKey: userDefaultsKey(String(i)))
                            .map { results + $0.toArray() }
                    }
                }
            )
    }

    func delete(key: String) -> Void {
        userDefaultsService.delete(forKey: userDefaultsKey(key))
    }

    func deleteAllLegacyConfigs() -> Void {
        for i in 0..<SaveLoadConfigServiceImpl.numberOfLegacySavedConfigs {
            self.delete(key: String(i))
        }
    }

    private func userDefaultsKey(_ key: String) -> String {
        "\(SaveLoadConfigServiceImpl.keyPrefix)_\(key)"
    }
}

extension SaveLoadConfigServiceImpl {
    static internal let keyPrefix = "saved_config"

    static internal let temporaryCurrentConfigKey = "temporaryCurrentConfig"

    static internal let configsKey = "configs"

    static internal let numberOfLegacySavedConfigs = 20
}

extension Container {
    var saveLoadConfigService: Factory<SaveLoadConfigService> {
        Factory(self) { SaveLoadConfigServiceImpl() }
    }
}

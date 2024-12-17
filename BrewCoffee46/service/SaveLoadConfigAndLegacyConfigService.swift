import BrewCoffee46Core
import Factory

public protocol SaveLoadConfigAndLegacyConfigService: SaveLoadConfigService {
    func loadAllLegacyConfigs() -> ResultNea<[Config], CoffeeError>

    func deleteAllLegacyConfigs() -> Void
}

final class SaveLoadConfigAndLegacyConfigServiceImpl: SaveLoadConfigAndLegacyConfigService {
    private let userDefaultsService = Container.shared.userDefaultsService()
    private let saveLoadConfigService = Container.shared.saveLoadConfigService()

    func legacyConfigDefaultsKey(_ key: String) -> String {
        "saved_config_\(key)"
    }

    func loadAllLegacyConfigs() -> ResultNea<[Config], CoffeeError> {
        return Array(0..<SaveLoadConfigAndLegacyConfigServiceImpl.numberOfLegacySavedConfigs)
            .reduce(
                .success([]),
                { (acc: ResultNea<[Config], CoffeeError>, i: Int) -> ResultNea<[Config], CoffeeError> in
                    acc.flatMap { results in
                        userDefaultsService
                            .getDecodable(forKey: legacyConfigDefaultsKey(String(i)))
                            .map { results + $0.toArray() }
                    }
                }
            )
    }

    func deleteAllLegacyConfigs() -> Void {
        for i in 0..<SaveLoadConfigAndLegacyConfigServiceImpl.numberOfLegacySavedConfigs {
            self.delete(key: String(i))
        }
    }

    func saveCurrentConfig(config: Config) -> ResultNea<Void, CoffeeError> {
        saveLoadConfigService.saveCurrentConfig(config: config)
    }

    func loadCurrentConfig() -> ResultNea<Config?, CoffeeError> {
        saveLoadConfigService.loadCurrentConfig()
    }

    func saveAll(configs: [Config]) -> ResultNea<Void, CoffeeError> {
        saveLoadConfigService.saveAll(configs: configs)
    }

    func loadAll() -> ResultNea<[Config]?, CoffeeError> {
        saveLoadConfigService.loadAll()
    }

    func saveConfig(config: Config) -> ResultNea<Void, CoffeeError> {
        saveLoadConfigService.saveConfig(config: config)
    }

    func delete(key: String) {
        saveLoadConfigService.delete(key: key)
    }
}

extension SaveLoadConfigAndLegacyConfigServiceImpl {
    static internal let numberOfLegacySavedConfigs = 20
}

extension Container {
    public var saveLoadConfigAndLegacyConfigService: Factory<SaveLoadConfigAndLegacyConfigService> {
        Factory(self) { SaveLoadConfigAndLegacyConfigServiceImpl() }
    }
}

import BrewCoffee46Core
import BrewCoffee46TestsShared
import Factory
import XCTest

@testable import BrewCoffee46

class MockJWTService: JWTService {
    let dummyConfigClaims: ResultNea<ConfigClaims, CoffeeError>
    let dummyStringFunc: (Config) -> ResultNea<String, CoffeeError>

    init(
        dummyConfigClaims: ResultNea<ConfigClaims, CoffeeError>,
        dummyStringFunc: @escaping (Config) -> ResultNea<String, CoffeeError>
    ) {
        self.dummyConfigClaims = dummyConfigClaims
        self.dummyStringFunc = dummyStringFunc
    }

    func verify(jwt: String) -> ResultNea<ConfigClaims, CoffeeError> {
        return dummyConfigClaims
    }

    func sign(config: Config) -> ResultNea<String, CoffeeError> {
        return dummyStringFunc(config)
    }
}

final class ConfigurationLinkServiceTests: XCTestCase {
    private func makeConfigClaims() -> ConfigClaims {
        ConfigClaims.init(
            iss: "iss",
            iat: getDate(),
            version: 1,
            config: Config.defaultValue()
        )
    }

    override func setUp() {
        super.setUp()
        Container.shared.reset()
    }

    func testGetFromURLSuccessfully() throws {
        let configClaims = makeConfigClaims()
        Container.shared.jwtService.register {
            MockJWTService(
                dummyConfigClaims: .success(configClaims),
                dummyStringFunc: { _ in .success("dummy") }
            )
        }
        let sut = ConfigurationLinkServiceImpl()

        let actual = sut.get(url: URL(string: "https://example.com/index?\(ConfigurationLinkServiceImpl.universalLinksQueryItemName)=data")!)
        XCTAssertEqual(actual, .success(configClaims))
    }

    func testGetReturnErrorIfQueryParameterIsNotFound() throws {
        let configClaims = makeConfigClaims()
        Container.shared.jwtService.register {
            MockJWTService(
                dummyConfigClaims: .success(configClaims),
                dummyStringFunc: { _ in .success("dummy") }
            )
        }
        let sut = ConfigurationLinkServiceImpl()

        let actual = sut.get(url: URL(string: "https://example.com/index")!)
        XCTAssertTrue(actual.isFailure())
        actual.forEachError { error in
            XCTAssertEqual(error.head, .configQueryParameterNotFound)
        }
    }

    func testGenerateURLSuccessfully() throws {
        let configClaims = makeConfigClaims()
        let dummyString = "dummy"
        let config = Config.defaultValue()
        let expectedEditedAtMilliSec = config.editedAtMilliSec
        Container.shared.jwtService.register {
            MockJWTService(
                dummyConfigClaims: .success(configClaims),
                dummyStringFunc: { config in
                    XCTAssertEqual(config.editedAtMilliSec, expectedEditedAtMilliSec)

                    return .success(dummyString)
                }
            )
        }
        let sut = ConfigurationLinkServiceImpl()

        let actual = sut.generate(config: config, currentConfigLastUpdatedAt: .none)
        XCTAssertEqual(
            actual,
            .success(
                ConfigurationLinkServiceImpl.universalLinksBaseURL.appending(
                    queryItems: [URLQueryItem(name: ConfigurationLinkServiceImpl.universalLinksQueryItemName, value: dummyString)]
                )
            ))
    }

    func testGenerateURLWithUpdateLastUpdatedAtSuccessfully() throws {
        let configClaims = makeConfigClaims()
        let dummyString = "dummy"
        let currentConfigLastUpdatedAt: UInt64 = 1000
        Container.shared.jwtService.register {
            MockJWTService(
                dummyConfigClaims: .success(configClaims),
                dummyStringFunc: { config in
                    XCTAssertEqual(config.editedAtMilliSec, .some(currentConfigLastUpdatedAt))

                    return .success(dummyString)
                }
            )
        }
        let sut = ConfigurationLinkServiceImpl()

        let actual = sut.generate(config: Config.defaultValue(), currentConfigLastUpdatedAt: currentConfigLastUpdatedAt)
        XCTAssertEqual(
            actual,
            .success(
                ConfigurationLinkServiceImpl.universalLinksBaseURL.appending(
                    queryItems: [URLQueryItem(name: ConfigurationLinkServiceImpl.universalLinksQueryItemName, value: dummyString)]
                )
            ))
    }
}

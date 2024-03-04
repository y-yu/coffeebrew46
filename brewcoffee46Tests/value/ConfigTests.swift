import XCTest

@testable import BrewCoffee46

final class ConfigTests: XCTestCase {
    func testDecodeFromJsonWithoutBeforeChecklistSuccessfully() throws {
        let expected = Config(
            coffeeBeansWeight: 24,
            partitionsCountOf6: 3,
            waterToCoffeeBeansWeightRatio: 16,
            firstWaterPercent: 0.5,
            totalTimeSec: 210,
            steamingTimeSec: 45,
            note: "note",
            beforeChecklist: Config.initBeforeCheckList,
            version: 1
        )
        let json = """
            {
                "waterToCoffeeBeansWeightRatio" : 16,
                "partitionsCountOf6" : 3,
                "coffeeBeansWeight" : 24,
                "version" : 1,
                "steamingTimeSec" : 45,
                "note" : "note",
                "firstWaterPercent" : 0.5,
                "totalTimeSec" : 210
            }
            """

        XCTAssertEqual(Config.fromJSON(json), .success(expected))
    }

    func testDecodeFromJsonSuccessfully() throws {
        let expected = Config(
            coffeeBeansWeight: 24,
            partitionsCountOf6: 3,
            waterToCoffeeBeansWeightRatio: 16,
            firstWaterPercent: 0.5,
            totalTimeSec: 210,
            steamingTimeSec: 45,
            note: "note",
            beforeChecklist: [
                "first",
                "second",
            ],
            version: 1
        )
        let json = """
            {
                "waterToCoffeeBeansWeightRatio" : 16,
                "partitionsCountOf6" : 3,
                "coffeeBeansWeight" : 24,
                "version" : 1,
                "steamingTimeSec" : 45,
                "note" : "note",
                "firstWaterPercent" : 0.5,
                "beforeChecklist": [ "first", "second" ],
                "totalTimeSec" : 210
            }
            """

        XCTAssertEqual(Config.fromJSON(json), .success(expected))
    }
}

import XCTest

@testable import BrewCoffee46Core

class GetDripPhaseServiceTests: XCTestCase {
    let sut = GetDripPhaseServiceImpl()

    func test_return_beforeDrip_if_the_progress_time_less_than_0() throws {
        let actual = sut.get(
            dripInfo: DripInfo.defaultValue,
            progressTime: -0.1
        )
        XCTAssertEqual(actual.totalNumberOfDrip, DripInfo.defaultValue.dripTimings.count)
        XCTAssertEqual(actual.dripPhaseType, .beforeDrip)
    }

    func test_return_dripping_if_the_progress_time_between_1st_and_2nd_drip_at() throws {
        let actual = sut.get(
            dripInfo: DripInfo.defaultValue,
            progressTime: 10
        )
        XCTAssertEqual(actual.dripPhaseType, .dripping(1))
    }

    func test_return_dripping_last_inedx_if_the_progress_time_is_close_total_time() throws {
        let actual = sut.get(
            dripInfo: DripInfo.defaultValue,
            progressTime: DripInfo.defaultValue.totalTimeSec
        )
        XCTAssertEqual(actual.dripPhaseType, .dripping(DripInfo.defaultValue.dripTimings.count))
    }

    func test_return_after_drip_if_the_progress_time_is_expired_at_total_time() throws {
        let actual = sut.get(
            dripInfo: DripInfo.defaultValue,
            progressTime: DripInfo.defaultValue.totalTimeSec + 0.1
        )
        XCTAssertEqual(actual.dripPhaseType, .afterDrip)
    }
}

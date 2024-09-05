import XCTest

@testable import BrewCoffee46Core

class DripPhaseTests: XCTestCase {
    func test_toInt_is_0_if_the_drip_phase_type_is_before_drip() throws {
        let sut = DripPhase(dripPhaseType: .beforeDrip, totalNumberOfDrip: 5)
        XCTAssertEqual(sut.toInt(), 0)
    }

    func test_toInt_is_n_minus_1_if_the_drip_phase_type_is_dripping() throws {
        let sut = DripPhase(dripPhaseType: .dripping(2), totalNumberOfDrip: 5)
        XCTAssertEqual(sut.toInt(), 1)
    }

    func test_toInt_is_equal_to_totalNumberOfDrip_if_the_drip_phase_type_is_after_drip() throws {
        let sut = DripPhase(dripPhaseType: .afterDrip, totalNumberOfDrip: 5)
        XCTAssertEqual(sut.toInt(), sut.totalNumberOfDrip)
    }
}

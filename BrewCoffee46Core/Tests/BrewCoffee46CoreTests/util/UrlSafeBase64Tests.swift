import XCTest

@testable import BrewCoffee46Core

final class UrlSafeBase64Tests: XCTestCase {
    let jsonString =
        "{\"waterToCoffeeBeansWeightRatio\":16,\"partitionsCountOf6\":3,\"coffeeBeansWeight\":24,\"version\":1,\"steamingTimeSec\":45,\"note\":\"note\",\"firstWaterPercent\":0.5,\"totalTimeSec\":210}"
    let urlSafeBase64 =
        "eyJ3YXRlclRvQ29mZmVlQmVhbnNXZWlnaHRSYXRpbyI6MTYsInBhcnRpdGlvbnNDb3VudE9mNiI6MywiY29mZmVlQmVhbnNXZWlnaHQiOjI0LCJ2ZXJzaW9uIjoxLCJzdGVhbWluZ1RpbWVTZWMiOjQ1LCJub3RlIjoibm90ZSIsImZpcnN0V2F0ZXJQZXJjZW50IjowLjUsInRvdGFsVGltZVNlYyI6MjEwfQ"

    func testUrlSafeBase64EncodeSuccessfully() throws {
        let actual = jsonString.encodeUrlSafeBase64()

        XCTAssertEqual(actual, .some(urlSafeBase64))
    }

    func testUrlSafeBase64DecodeSuccessfully() throws {
        let actual = urlSafeBase64.decodeUrlSafeBase64()

        XCTAssertEqual(actual, .some(jsonString))
    }
}

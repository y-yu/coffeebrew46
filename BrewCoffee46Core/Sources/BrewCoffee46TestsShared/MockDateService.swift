import BrewCoffee46Core
import Foundation

public class MockDateService: DateService {
    let date: Date

    public init(_ now: Date) {
        date = now
    }

    public init() {
        date = epochTimeMillis.toDate()
    }

    public func now() -> Date {
        date
    }

    public func nowEpochTimeMillis() -> UInt64 {
        date.toEpochTimeMillis()
    }
}

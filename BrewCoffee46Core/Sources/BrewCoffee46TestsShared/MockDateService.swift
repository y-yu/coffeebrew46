import BrewCoffee46Core
import Foundation

public class MockDateService: DateService {
    let date: Date

    init(_ now: Date) {
        date = now
    }

    init() {
        date = epochTimeMillis.toDate()
    }

    public func now() -> Date {
        date
    }

    public func nowEpochTimeMillis() -> UInt64 {
        date.toEpochTimeMillis()
    }
}

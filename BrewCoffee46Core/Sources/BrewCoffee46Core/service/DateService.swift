import Factory
import Foundation

public protocol DateService {
    func now() -> Date

    func nowEpochTimeMillis() -> UInt64
}

public class DateServiceImpl: DateService {
    public func now() -> Date {
        Date.now
    }

    public func nowEpochTimeMillis() -> UInt64 {
        UInt64(now().timeIntervalSince1970 * 1000)
    }
}

extension Container {
    public var dateService: Factory<DateService> {
        Factory(self) { DateServiceImpl() }
    }
}

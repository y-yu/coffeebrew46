import Foundation

extension Date {
    public func toEpochTimeMillis() -> UInt64 {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }
}

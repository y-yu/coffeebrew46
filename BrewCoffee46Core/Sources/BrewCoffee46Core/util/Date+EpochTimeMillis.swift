import Foundation

extension Date {
    public func toEpochTimeMillis() -> UInt64 {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }

    public static func nowEpochTimeMillis() -> UInt64 {
        return Date().toEpochTimeMillis()
    }
}

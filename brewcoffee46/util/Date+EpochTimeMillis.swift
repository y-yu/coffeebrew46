import Foundation

extension Date {
    func toEpochTimeMillis() -> UInt64 {
        return UInt64(self.timeIntervalSince1970 * 1000)
    }

    static func nowEpochTimeMillis() -> UInt64 {
        return Date().toEpochTimeMillis()
    }
}

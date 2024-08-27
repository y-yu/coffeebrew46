import Foundation

extension UInt64 {
    public func toDate() -> Date {
        return Date(timeIntervalSince1970: Double(self) / 1000)
    }
}

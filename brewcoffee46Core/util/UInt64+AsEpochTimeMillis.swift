import Foundation

extension UInt64 {
    func toDate() -> Date {
        return Date(timeIntervalSince1970: Double(self) / 1000)
    }
}

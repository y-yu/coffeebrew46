import Foundation

class DateUtils {
    class func dateFromString(_ string: String, format: String) -> Date {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.date(from: string)!
    }

    class func stringFromDate(date: Date, format: String) -> String {
        let formatter: DateFormatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .gregorian)
        formatter.dateFormat = format
        return formatter.string(from: date)
    }
}

let epochTimeMillis: UInt64 = 1_723_792_539_843

func getDate() -> Date {
    let f = ISO8601DateFormatter()
    f.formatOptions.insert(.withFractionalSeconds)

    return f.date(from: "2024-08-16T07:15:39.843Z")!
}

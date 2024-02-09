import Foundation

struct RequestReviewItem: Equatable {
    var appVersion: String
    
    var requestedDate: Date
    
    enum CodingKeys: String, CodingKey {
        case appVersion
        case requestedDate
    }
}

func == (lhs: RequestReviewItem, rhs: RequestReviewItem) -> Bool {
    lhs.appVersion == rhs.appVersion &&
    lhs.requestedDate == rhs.requestedDate
}

extension RequestReviewItem: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        appVersion = try values.decode(String.self, forKey: .appVersion)
        requestedDate = Date(timeIntervalSince1970: try values.decode(Double.self, forKey: .requestedDate))
    }
}

extension RequestReviewItem: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(appVersion, forKey: .appVersion)
        try container.encode(requestedDate.timeIntervalSince1970, forKey: .requestedDate)
    }
}

struct RequestReviewInfo: Equatable {
    var requestHistory: [RequestReviewItem]
    
    enum CodingKeys: String, CodingKey {
        case requestHistory
    }
}

extension RequestReviewInfo: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        requestHistory = try values.decode([RequestReviewItem].self, forKey: .requestHistory)
    }
}

extension RequestReviewInfo: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(requestHistory, forKey: .requestHistory)
    }
}

func == (lhs: RequestReviewInfo, rhs: RequestReviewInfo) -> Bool {
    if lhs.requestHistory.count == rhs.requestHistory.count {
        for (index, item) in lhs.requestHistory.enumerated() {
            if item != rhs.requestHistory[index] {
                return false
            }
        }
        return true
    } else {
        return false
    }
}

struct RequestReviewGuard {
    var tryCount: Int
    
    enum CodingKeys: String, CodingKey {
        case tryCount
    }
}

extension RequestReviewGuard: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        tryCount = try values.decode(Int.self, forKey: .tryCount)
    }
}

extension RequestReviewGuard: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(tryCount, forKey: .tryCount)
    }
}

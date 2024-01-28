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

extension RequestReviewInfo {
    func toJSON(isPrettyPrint: Bool) -> ResultNel<String, CoffeeError> {
        let encoder = JSONEncoder()
        if isPrettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        do {
            return Result.success(try String(data: encoder.encode(self), encoding: .utf8)!)
        } catch {
            return Result.failure(NonEmptyList(CoffeeError.jsonError))
        }
    }

    static func fromJSON(_ json: String) -> ResultNel<RequestReviewInfo, CoffeeError> {
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        do {
            let config = try decoder.decode(RequestReviewInfo.self, from: jsonData)
            return Result.success(config)
        } catch {
            return Result.failure(NonEmptyList(CoffeeError.jsonError))
        }
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


import Foundation

struct Config: Equatable {
    var coffeeBeansWeight: Double
    
    var partitionsCountOf6: Double
    
    var waterToCoffeeBeansWeightRatio: Double

    var firstWaterPercent: Double
    
    var totalTimeSec: Double
    
    var steamingTimeSec: Double
    
    // If the JSON compatibility of `Config` falls then `version` will increment.
    var version: Int
    
    enum CodingKeys: String, CodingKey {
        case coffeeBeansWeight
        case partitionsCountOf6
        case waterToCoffeeBeansWeightRatio
        case firstWaterPercent
        case totalTimeSec
        case steamingTimeSec
        case version
    }
    
    init() {
        coffeeBeansWeight = 30
        partitionsCountOf6 = 3
        waterToCoffeeBeansWeightRatio = 15
        firstWaterPercent = 0.5
        totalTimeSec = 210
        steamingTimeSec = 45
        version = Config.currentVersion
    }
}

extension Config {
    static let currentVersion: Int = 1
    
    func totalWaterAmount() -> Double {
        self.coffeeBeansWeight * self.waterToCoffeeBeansWeightRatio
    }
    
    func fortyPercentWaterAmount() -> Double {
        totalWaterAmount() * 0.4
    }
    
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

    static func fromJSON(_ json: String) -> ResultNel<Config, CoffeeError> {
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        do {
            let config = try decoder.decode(Config.self, from: jsonData)
            if (config.version == currentVersion) {
                return Result.success(config)
            } else {
                return Result.failure(NonEmptyList(CoffeeError.loadedConfigIsNotCompatible))
            }
        } catch {
            return Result.failure(NonEmptyList(CoffeeError.jsonError))
        }
    }
}

extension Config: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coffeeBeansWeight = try values.decode(Double.self, forKey: .coffeeBeansWeight)
        partitionsCountOf6 = try Double(values.decode(Int.self, forKey: .partitionsCountOf6))
        waterToCoffeeBeansWeightRatio = try values.decode(Double.self, forKey: .waterToCoffeeBeansWeightRatio)
        firstWaterPercent = try values.decode(Double.self, forKey: .firstWaterPercent)
        totalTimeSec = try Double(values.decode(Int.self, forKey: .totalTimeSec))
        steamingTimeSec = try Double(values.decode(Int.self, forKey: .steamingTimeSec))
        version = try values.decode(Int.self, forKey: .version)
    }
}

extension Config: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coffeeBeansWeight, forKey: .coffeeBeansWeight)
        try container.encode(Int(partitionsCountOf6), forKey: .partitionsCountOf6)
        try container.encode(waterToCoffeeBeansWeightRatio, forKey: .waterToCoffeeBeansWeightRatio)
        try container.encode(firstWaterPercent, forKey: .firstWaterPercent)
        try container.encode(totalTimeSec, forKey: .totalTimeSec)
        try container.encode(steamingTimeSec, forKey: .steamingTimeSec)
        try container.encode(version, forKey: .version)
    }
}

func ==(lhs: Config, rhs: Config) -> Bool {
    lhs.coffeeBeansWeight == rhs.coffeeBeansWeight &&
    lhs.firstWaterPercent == rhs.firstWaterPercent &&
    lhs.partitionsCountOf6 == rhs.partitionsCountOf6 &&
    lhs.steamingTimeSec == rhs.steamingTimeSec &&
    lhs.totalTimeSec == rhs.totalTimeSec &&
    lhs.waterToCoffeeBeansWeightRatio == rhs.waterToCoffeeBeansWeightRatio &&
    lhs.version == rhs.version
}

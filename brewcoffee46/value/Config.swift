import Foundation

struct Config: Equatable {
    var coffeeBeansWeight: Double

    var partitionsCountOf6: Double

    var waterToCoffeeBeansWeightRatio: Double

    var firstWaterPercent: Double

    var totalTimeSec: Double

    var steamingTimeSec: Double

    var note: String?

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
        case note
    }

    init() {
        coffeeBeansWeight = Config.initCoffeeBeansWeight
        partitionsCountOf6 = 3
        waterToCoffeeBeansWeightRatio = Config.initWaterToCoffeeBeansWeightRatio
        firstWaterPercent = 0.5
        totalTimeSec = 210
        steamingTimeSec = 45
        note = .some("")
        version = Config.currentVersion
    }
}

extension Config {
    static let currentVersion: Int = 1

    static let initCoffeeBeansWeight: Double = 30.0

    static let initWaterToCoffeeBeansWeightRatio: Double = 15.0

    func totalWaterAmount() -> Double {
        roundCentesimal(coffeeBeansWeight * self.waterToCoffeeBeansWeightRatio)
    }

    func fortyPercentWaterAmount() -> Double {
        roundCentesimal(totalWaterAmount() * 0.4)
    }

    func toJSON(isPrettyPrint: Bool) -> ResultNea<String, CoffeeError> {
        let encoder = JSONEncoder()
        if isPrettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        do {
            return Result.success(try String(data: encoder.encode(self), encoding: .utf8)!)
        } catch {
            return Result.failure(NonEmptyArray(CoffeeError.jsonError(error)))
        }
    }

    static func fromJSON(_ json: String) -> ResultNea<Config, CoffeeError> {
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        do {
            let config = try decoder.decode(Config.self, from: jsonData)
            if config.version == currentVersion {
                return Result.success(config)
            } else {
                return Result.failure(NonEmptyArray(CoffeeError.loadedConfigIsNotCompatible))
            }
        } catch {
            return Result.failure(NonEmptyArray(CoffeeError.jsonError(error)))
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
        note = try values.decodeIfPresent(String.self, forKey: .note)
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
        try container.encodeIfPresent(note, forKey: .note)
        try container.encode(version, forKey: .version)
    }
}

func == (lhs: Config, rhs: Config) -> Bool {
    lhs.coffeeBeansWeight == rhs.coffeeBeansWeight && lhs.firstWaterPercent == rhs.firstWaterPercent
        && lhs.partitionsCountOf6 == rhs.partitionsCountOf6 && lhs.steamingTimeSec == rhs.steamingTimeSec && lhs.totalTimeSec == rhs.totalTimeSec
        && lhs.waterToCoffeeBeansWeightRatio == rhs.waterToCoffeeBeansWeightRatio && lhs.note == rhs.note && lhs.version == rhs.version
}

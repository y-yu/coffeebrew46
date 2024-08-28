import Foundation

public struct Config: Equatable {
    public var coffeeBeansWeight: Double {
        didSet {
            if coffeeBeansWeight != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var partitionsCountOf6: Double {
        didSet {
            if partitionsCountOf6 != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var waterToCoffeeBeansWeightRatio: Double {
        didSet {
            if waterToCoffeeBeansWeightRatio != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var firstWaterPercent: Double {
        didSet {
            if firstWaterPercent != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var totalTimeSec: Double {
        didSet {
            if totalTimeSec != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var steamingTimeSec: Double {
        didSet {
            if steamingTimeSec != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var note: String? {
        didSet {
            if note != oldValue {
                updateLastEditedAt()
            }
        }
    }

    public var beforeChecklist: [String] {
        didSet {
            if beforeChecklist != oldValue {
                updateLastEditedAt()
            }
        }
    }

    /// Unix epoch time as milli seconds.
    public var editedAtMilliSec: UInt64?

    // If the JSON compatibility of `Config` falls then `version` will increment.
    public var version: Int

    private mutating func updateLastEditedAt() {
        self.editedAtMilliSec = .some(Date.nowEpochTimeMillis())
    }

    enum CodingKeys: String, CodingKey {
        case coffeeBeansWeight
        case partitionsCountOf6
        case waterToCoffeeBeansWeightRatio
        case firstWaterPercent
        case totalTimeSec
        case steamingTimeSec
        case version
        case note
        case beforeChecklist
        case editedAtMilliSec
    }

    public init(
        coffeeBeansWeight: Double,
        partitionsCountOf6: Double,
        waterToCoffeeBeansWeightRatio: Double,
        firstWaterPercent: Double,
        totalTimeSec: Double,
        steamingTimeSec: Double,
        note: String,
        beforeChecklist: [String],
        editedAtMilliSec: UInt64?,
        version: Int = Config.currentVersion
    ) {
        self.coffeeBeansWeight = coffeeBeansWeight
        self.partitionsCountOf6 = partitionsCountOf6
        self.waterToCoffeeBeansWeightRatio = waterToCoffeeBeansWeightRatio
        self.firstWaterPercent = firstWaterPercent
        self.totalTimeSec = totalTimeSec
        self.steamingTimeSec = steamingTimeSec
        self.note = .some(note)
        self.beforeChecklist = beforeChecklist
        self.editedAtMilliSec = editedAtMilliSec
        self.version = version
    }

    public init() {
        coffeeBeansWeight = Config.initCoffeeBeansWeight
        partitionsCountOf6 = 3
        waterToCoffeeBeansWeightRatio = Config.initWaterToCoffeeBeansWeightRatio
        firstWaterPercent = 0.5
        totalTimeSec = 210
        steamingTimeSec = 45
        note = .some("")
        beforeChecklist = Config.initBeforeCheckList
        editedAtMilliSec = .some(Date.nowEpochTimeMillis())
        version = Config.currentVersion
    }
}

extension Config {
    public static let currentVersion: Int = 1

    public static let initCoffeeBeansWeight: Double = 30.0

    public static let initWaterToCoffeeBeansWeightRatio: Double = 15.0

    public static let maxCheckListSize = 100

    public static let initBeforeCheckList: [String] = (1...9).map { i in
        NSLocalizedString("before check list \(i)", comment: "")
    }

    public func totalWaterAmount() -> Double {
        roundCentesimal(coffeeBeansWeight * self.waterToCoffeeBeansWeightRatio)
    }

    public func fortyPercentWaterAmount() -> Double {
        roundCentesimal(totalWaterAmount() * 0.4)
    }

    public func toJSON(isPrettyPrint: Bool) -> ResultNea<String, CoffeeError> {
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

    public static func fromJSON(_ json: String) -> ResultNea<Config, CoffeeError> {
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
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        coffeeBeansWeight = try values.decode(Double.self, forKey: .coffeeBeansWeight)
        partitionsCountOf6 = try Double(values.decode(Int.self, forKey: .partitionsCountOf6))
        waterToCoffeeBeansWeightRatio = try values.decode(Double.self, forKey: .waterToCoffeeBeansWeightRatio)
        firstWaterPercent = try values.decode(Double.self, forKey: .firstWaterPercent)
        totalTimeSec = try Double(values.decode(Int.self, forKey: .totalTimeSec))
        steamingTimeSec = try Double(values.decode(Int.self, forKey: .steamingTimeSec))
        note = try values.decodeIfPresent(String.self, forKey: .note)
        let rawBeforeChecklist = try values.decodeIfPresent([String].self, forKey: .beforeChecklist) ?? Config.initBeforeCheckList
        beforeChecklist = Array(rawBeforeChecklist.prefix(Config.maxCheckListSize))
        editedAtMilliSec = try values.decodeIfPresent(UInt64.self, forKey: .editedAtMilliSec)
        version = try values.decode(Int.self, forKey: .version)
    }
}

extension Config: Encodable {
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(coffeeBeansWeight, forKey: .coffeeBeansWeight)
        try container.encode(Int(partitionsCountOf6), forKey: .partitionsCountOf6)
        try container.encode(waterToCoffeeBeansWeightRatio, forKey: .waterToCoffeeBeansWeightRatio)
        try container.encode(firstWaterPercent, forKey: .firstWaterPercent)
        try container.encode(totalTimeSec, forKey: .totalTimeSec)
        try container.encode(steamingTimeSec, forKey: .steamingTimeSec)
        try container.encodeIfPresent(note, forKey: .note)
        try container.encode(beforeChecklist, forKey: .beforeChecklist)
        try container.encodeIfPresent(editedAtMilliSec, forKey: .editedAtMilliSec)
        try container.encode(version, forKey: .version)
    }
}

public func == (lhs: Config, rhs: Config) -> Bool {
    lhs.coffeeBeansWeight == rhs.coffeeBeansWeight && lhs.firstWaterPercent == rhs.firstWaterPercent
        && lhs.partitionsCountOf6 == rhs.partitionsCountOf6 && lhs.steamingTimeSec == rhs.steamingTimeSec && lhs.totalTimeSec == rhs.totalTimeSec
        && lhs.waterToCoffeeBeansWeightRatio == rhs.waterToCoffeeBeansWeightRatio && lhs.note == rhs.note
        && lhs.beforeChecklist == rhs.beforeChecklist && lhs.editedAtMilliSec == rhs.editedAtMilliSec && lhs.version == rhs.version
}

extension Config: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(coffeeBeansWeight)
        hasher.combine(partitionsCountOf6)
        hasher.combine(firstWaterPercent)
        hasher.combine(steamingTimeSec)
        hasher.combine(totalTimeSec)
        hasher.combine(waterToCoffeeBeansWeightRatio)
        hasher.combine(note)
        hasher.combine(beforeChecklist)
        hasher.combine(editedAtMilliSec)
        hasher.combine(version)
    }
}
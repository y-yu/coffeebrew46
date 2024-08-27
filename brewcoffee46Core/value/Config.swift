import Foundation

struct Config: Equatable {
    var coffeeBeansWeight: Double {
        didSet {
            if coffeeBeansWeight != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var partitionsCountOf6: Double {
        didSet {
            if partitionsCountOf6 != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var waterToCoffeeBeansWeightRatio: Double {
        didSet {
            if waterToCoffeeBeansWeightRatio != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var firstWaterPercent: Double {
        didSet {
            if firstWaterPercent != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var totalTimeSec: Double {
        didSet {
            if totalTimeSec != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var steamingTimeSec: Double {
        didSet {
            if steamingTimeSec != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var note: String? {
        didSet {
            if note != oldValue {
                updateLastEditedAt()
            }
        }
    }

    var beforeChecklist: [String] {
        didSet {
            if beforeChecklist != oldValue {
                updateLastEditedAt()
            }
        }
    }

    /// Unix epoch time as milli seconds.
    var editedAtMilliSec: UInt64?

    // If the JSON compatibility of `Config` falls then `version` will increment.
    var version: Int

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

    init(
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

    init() {
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
    static let currentVersion: Int = 1

    static let initCoffeeBeansWeight: Double = 30.0

    static let initWaterToCoffeeBeansWeightRatio: Double = 15.0

    static let maxCheckListSize = 100

    static let initBeforeCheckList: [String] = (1...9).map { i in
        NSLocalizedString("before check list \(i)", comment: "")
    }

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
        let rawBeforeChecklist = try values.decodeIfPresent([String].self, forKey: .beforeChecklist) ?? Config.initBeforeCheckList
        beforeChecklist = Array(rawBeforeChecklist.prefix(Config.maxCheckListSize))
        editedAtMilliSec = try values.decodeIfPresent(UInt64.self, forKey: .editedAtMilliSec)
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
        try container.encode(beforeChecklist, forKey: .beforeChecklist)
        try container.encodeIfPresent(editedAtMilliSec, forKey: .editedAtMilliSec)
        try container.encode(version, forKey: .version)
    }
}

func == (lhs: Config, rhs: Config) -> Bool {
    lhs.coffeeBeansWeight == rhs.coffeeBeansWeight && lhs.firstWaterPercent == rhs.firstWaterPercent
        && lhs.partitionsCountOf6 == rhs.partitionsCountOf6 && lhs.steamingTimeSec == rhs.steamingTimeSec && lhs.totalTimeSec == rhs.totalTimeSec
        && lhs.waterToCoffeeBeansWeightRatio == rhs.waterToCoffeeBeansWeightRatio && lhs.note == rhs.note
        && lhs.beforeChecklist == rhs.beforeChecklist && lhs.editedAtMilliSec == rhs.editedAtMilliSec && lhs.version == rhs.version
}

extension Config: Hashable {
    func hash(into hasher: inout Hasher) {
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

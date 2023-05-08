import Foundation

struct Config: Equatable {
    var coffeeBeansWeight: Double
    
    var partitionsCountOf6: Double
    
    var waterToCoffeeBeansWeightRatio: Double

    var firstWaterPercent: Double
    
    var totalTimeSec: Double
    
    var steamingTimeSec: Double
    
    enum CodingKeys: String, CodingKey {
        case coffeeBeansWeight
        case partitionsCountOf6
        case waterToCoffeeBeansWeightRatio
        case firstWaterPercent
        case totalTimeSec
        case steamingTimeSec
    }
    
    init() {
        coffeeBeansWeight = 30
        partitionsCountOf6 = 3
        waterToCoffeeBeansWeightRatio = 15
        firstWaterPercent = 0.5
        totalTimeSec = 210
        steamingTimeSec = 55
    }
}

extension Config {
    func totalWaterAmount() -> Double {
        self.coffeeBeansWeight * self.waterToCoffeeBeansWeightRatio
    }
    
    func fortyPercentWaterAmount() -> Double {
        totalWaterAmount() * 0.4
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
    }
}

func ==(lhs: Config, rhs: Config) -> Bool {
    lhs.coffeeBeansWeight == rhs.coffeeBeansWeight &&
    lhs.firstWaterPercent == rhs.firstWaterPercent &&
    lhs.partitionsCountOf6 == rhs.partitionsCountOf6 &&
    lhs.steamingTimeSec == rhs.steamingTimeSec &&
    lhs.totalTimeSec == rhs.totalTimeSec &&
    lhs.waterToCoffeeBeansWeightRatio == rhs.waterToCoffeeBeansWeightRatio
}

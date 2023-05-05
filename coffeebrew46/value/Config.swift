import Foundation

struct Config {
    var coffeeBeansWeight: Double
    
    var partitionsCountOf6: Double
    
    var waterToCoffeeBeansWeightRatio: Double

    var firstWaterPercent: Double
    
    var totalTimeSec: Double
    
    var steamingTimeSec: Double
    
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
}

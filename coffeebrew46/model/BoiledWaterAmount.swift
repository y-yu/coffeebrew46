struct BoiledWaterAmount {
    let totalAmount: Double
    let values: (Double, Double, Double, Double, Double)
    
    init(totalAmount: Double, f: (Double) -> (Double, Double, Double, Double, Double)) {
        self.totalAmount = totalAmount
        self.values = f(totalAmount)
    }
}

extension BoiledWaterAmount {
    func toString() -> String {
        return "\(values.0), \(values.1), \(values.2), \(values.3), \(values.4)"
    }
}

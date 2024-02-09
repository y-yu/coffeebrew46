/// # Water amount for 4:6 method.
struct WaterAmount {
    // The first and second water amounts (gram)
    var fortyPercent: (Double, Double)

    // Others water amounts (gram)
    var sixtyPercent: NonEmptyArray<Double>
}

extension WaterAmount {
    // Return total amount of the water (gram).
    func totalAmount() -> Double {
        fortyPercent.0 + fortyPercent.1
            + sixtyPercent.toArray().reduce(
                0.0,
                { (acc, v) in return acc + v }
            )
    }

    func toArray() -> [Double] {
        if fortyPercent.1 <= 0 {
            return [fortyPercent.0] + sixtyPercent.toArray()
        } else {
            return [fortyPercent.0, fortyPercent.1] + sixtyPercent.toArray()
        }
    }
}

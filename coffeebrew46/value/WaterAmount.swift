/**
 # Water amount for 4:6 method.
 */
struct WaterAmount {
    // The first and second water amounts (gram)
    var fortyPercent: (Double, Double)

    // Others water amounts (gram)
    var sixtyPercent: NonEmptyList<Double>
    
    // Return total amount of the water (gram).
    func totalAmount() -> Double {
        fortyPercent.0 +
            fortyPercent.1 +
            sixtyPercent.toArray().reduce(
                0.0,
                { (acc, v) in return acc + v }
            )
    }
}

/**
 # Boild water amount for 4:6 method.
 */
struct BoiledWaterAmount {
    // The first and second warter amounts (gram)
    let fourtyPercent: (Double, Double)

    // Others warter amounts (gram)
    let sixtyPercent: NonEmptyList<Double>
    
    // Return total amount of the water (gram).
    func totalAmount() -> Double {
        fourtyPercent.0 +
            fourtyPercent.1 +
            sixtyPercent.toArray().reduce(
                0.0,
                { (acc, v) in return acc + v }
            )
    }
}

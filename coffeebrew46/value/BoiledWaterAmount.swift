/**
 # Boild water amount for 4:6 method.
 */
struct BoiledWaterAmount {
    let fourtyPercent: (Double, Double)
    let sixtyPercent: NonEmptyList<Double>
    
    // Return total amount of the water.
    func totalAmount() -> Double {
        fourtyPercent.0 +
            fourtyPercent.1 +
            sixtyPercent.toArray().reduce(
                0.0,
                { (acc, v) in return acc + v }
            )
    }
}

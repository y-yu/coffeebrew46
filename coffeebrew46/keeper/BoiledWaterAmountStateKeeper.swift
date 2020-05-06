import SwiftUI

/**
 # Interface for Warter amount presentation.

 The type `ResultView` should be some states which is in ViewModel.
 This is an interface to update the states based on the result.
*/
protocol BoiledWaterAmountStateKeeper {
    func update(
        result: ResultNel<BoiledWaterAmount, CoffeeError>,
        environment: Binding<String>
    ) -> Void
}

class BoiledWaterAmountStateKeeperImpl: BoiledWaterAmountStateKeeper {
    func update(
        result: ResultNel<BoiledWaterAmount, CoffeeError>,
        environment: Binding<String>
    ) -> Void {
        
    }
}

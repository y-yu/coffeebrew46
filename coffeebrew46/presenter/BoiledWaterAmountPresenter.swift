import SwiftUI

/*
 # Interface for Warter amount presentation.
 
 The type `ResultView` should be some `View` type which would be
 shown to the user as a view object.
 */
protocol BoiledWaterAmountPresenter {
    associatedtype ResultView: View
    
    // ViewModel requires an initial view. This field is representing it.
    static var unit: ResultView { get }
    
    func show(result: Either<CoffeeError, BoiledWaterAmount>) -> ResultView
}

// An implementation.
class BoiledWaterAmountPresenterImpl: BoiledWaterAmountPresenter {
    typealias ResultView = Text
    
    static let unit: ResultView = Text("")
    
    func show(result: Either<CoffeeError, BoiledWaterAmount>) -> Text {
        switch result {
        case .Right(let boiledWaterAmount):
            // Don't use string interporation!
            // See also: https://twitter.com/_yyu_/status/1255404728638410754?s=20
            return Text("Boiled water amounts are " + boiledWaterAmount.toString())
        case .Left(let coffeeError):
            return Text(coffeeError.message)
        }
    }
}

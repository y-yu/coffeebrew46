import SwiftUI

/**
 # Interface for Warter amount presentation.

 The type `ResultView` should be some `View` type which would be
 shown to the user as a view object.
 */
protocol BoiledWaterAmountPresenter {
    associatedtype ResultView: CoproductView
    
    // ViewModel requires an initial view. This field is representing it.
    static var unit: ResultView { get }
    
    func show(result: ResultNel<BoiledWaterAmount, CoffeeError>) -> ResultView
}

// An implementation.
class BoiledWaterAmountPresenterImpl: BoiledWaterAmountPresenter {
    typealias ResultView = CCons<Text, CNil<Image>>
    
    static let unit: CCons<Text, CNil<Image>> =
        CCons<Text, CNil<Image>>.apply(Text(""))
    
    func show(result: ResultNel<BoiledWaterAmount, CoffeeError>) -> CCons<Text,
    CNil<Image>> {
        switch result {
        case .success(let boiledWaterAmount):
            // Don't use string interporation!
            // See also: https://twitter.com/_yyu_/status/1255404728638410754?s=20
            return CCons<Text, CNil<Image>>
                .apply(Text("Boiled water amounts are " + boiledWaterAmount.toString()))
        case .failure(/* let coffeeErrors*/ _):
            return CCons<Text, CNil<Image>>
                .apply(CNil(Image("wood_nata")))
        }
    }
}

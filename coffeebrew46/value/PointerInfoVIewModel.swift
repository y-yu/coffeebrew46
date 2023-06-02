import SwiftUI

/**
 # A tuple for color and degree of the pointer.
 */
struct PointerInfoViewModel {
    // Value of the pointer.
    var value: Double
    var degree: Double
    // Drip timing (sec)
    var dripAt: Double
}

final class PointerInfoViewModels: ObservableObject {
    @Published var pointerInfo: Array<PointerInfoViewModel>
    
    init(pointerInfo: Array<PointerInfoViewModel> = []) {
        self.pointerInfo = pointerInfo
    }
}

extension PointerInfoViewModels {
    static var defaultValue =
        fromTuples(
            (90, 0.0, 0.0),
            (180, 72.0, 45.0),
            (270, 144.0, 86.25),
            (360, 216.0, 127.5),
            (450, 288.0, 168.75)
        )
    
    static func fromArray(_ arr: Array<(Double, Double, Double)>) -> PointerInfoViewModels {
        PointerInfoViewModels(
            pointerInfo: arr.map { (value, degree, dripAt) in
                PointerInfoViewModel(
                    value: value,
                    degree: degree,
                    dripAt: dripAt
                )
            }
        )
    }
    
    static func fromTuples(_ tuples: (Double, Double, Double)...) -> PointerInfoViewModels {
        fromArray(tuples)
    }
}

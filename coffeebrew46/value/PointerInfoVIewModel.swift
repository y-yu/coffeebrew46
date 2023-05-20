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
    
    init() {
        self.pointerInfo = []
    }

    func withColorAndDegrees(_ arr: Array<(Double, Double, Double)>) -> PointerInfoViewModels {
        self.pointerInfo = arr.map { (value, degree, dripAt) in
            PointerInfoViewModel(
                value: value,
                degree: degree,
                dripAt: dripAt
            )
        }
        
        return self
    }
    
    static func withColorAndDegrees(_ tuples: (Double, Double, Double)...) -> PointerInfoViewModels {
        return PointerInfoViewModels().withColorAndDegrees([]).withColorAndDegrees(tuples)
    }
}

extension PointerInfoViewModels {
    static var defaultValue =
        PointerInfoViewModels.withColorAndDegrees(
            (0.0, 0.0, 0.0),
            (120, 72.0, 55.0),
            (180, 144.0, 106.666666),
            (240, 216.0, 158.333333),
            (300, 288.0, 209.999999)
        )
}

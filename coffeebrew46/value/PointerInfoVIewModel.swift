import SwiftUI

/**
 # A tuple for color and degree of the pointer.
 */
struct PointerInfoViewModel {
    // Value of the pointer.
    var value: Double
    var degree: Double
}

final class PointerInfoViewModels: ObservableObject {
    @Published var pointerInfo: Array<PointerInfoViewModel>
    
    init() {
        self.pointerInfo = []
    }

    func withColorAndDegrees(_ arr: Array<(Double, Double)>) -> PointerInfoViewModels {
        self.pointerInfo = arr.map { (value, degree) in
            PointerInfoViewModel(
                value: value,
                degree: degree
            )
        }
        
        return self
    }
    
    static func withColorAndDegrees(_ tuples: (Double, Double)...) -> PointerInfoViewModels {
        return PointerInfoViewModels().withColorAndDegrees([]).withColorAndDegrees(tuples)
    }
}


import SwiftUI

/**
 # A tuple for color and degree of the pointer.
 */
final class PointerInfoViewModel {
    // Value of the pointer.
    public let value: Double
    
    // This is an event sender function for the parent model.
    // This model will be an element of the array of `PointerInfoViewModels`,
    // but SwiftUI won't detect that `PointerInfoViewModels` was changed
    // even if this model as its element had been changed...
    // That behavior seems to be a bug of SwiftUI, isn't it?
    // Anyway, for now it's needed to call the parent model's `objectWillChange` method
    // that's the why this private function is defined.
    private let send: () -> ()
    
    var degree: Double = 0.0 {
        didSet {
            self.send()
        }
    }
    
    init(
        value: Double,
        initDegrees: Double = 0.0,
        send: @escaping () -> ()
    ) {
        self.degree = initDegrees
        self.send = send
        self.value = value
    }
}

final class PointerInfoViewModels: ObservableObject {
    @Published var pointerInfo: Array<PointerInfoViewModel>
    
    init() {
        self.pointerInfo = []
    }

    func withColorAndDegrees(_ arr: Array<(Double, Double)>) -> PointerInfoViewModels {
        self.pointerInfo = arr.map { (value, initDegrees) in
            PointerInfoViewModel(
                value: value,
                initDegrees: initDegrees,
                send: { self.objectWillChange.send() }
            )
        }
        
        return self
    }
    
    static func withColorAndDegrees(_ tuples: (Double, Double)...) -> PointerInfoViewModels {
        return PointerInfoViewModels().withColorAndDegrees([]).withColorAndDegrees(tuples)
    }
}


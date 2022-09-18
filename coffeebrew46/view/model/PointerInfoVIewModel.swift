import SwiftUI

/**
 # A tuple for color and degree of the pointer.
 */
final class PointerInfoViewModel {
    public var color: Color
    
    // This is an event sender function for the parent model.
    // This model will be an element of the array of `PointerInfoViewModels`,
    // but SwiftUI won't detect that `PointerInfoViewModels` was changed
    // even if this model as its element had been changed...
    // That behavior seems to be a bug of SwiftUI, isn't it?
    // Anyway, for now it's needed to call the parent model's `objectWillChange` method
    // that's the why this private function is defined.
    private let send: () -> ()
    
    var degrees: Double = 0.0 {
        didSet {
            self.send()
        }
    }

    public var isEnd: Bool
    
    init(
        color: Color,
        initDegrees: Double = 0.0,
        send: @escaping () -> ()
    ) {
        self.degrees = initDegrees
        self.color = color
        self.send = send
        self.isEnd = false
    }
}

final class PointerInfoViewModels: ObservableObject {
    @Published var pointerInfo: Array<PointerInfoViewModel>
    
    init() {
        self.pointerInfo = []
    }

    func withColorAndDegrees(_ arr: Array<(Color, Double)>) -> PointerInfoViewModels {
        self.pointerInfo = arr.map { (color, initDegrees) in
            PointerInfoViewModel(
                color: color,
                initDegrees: initDegrees,
                send: { self.objectWillChange.send() }
            )
        }
        
        return self
    }
    
    static func withColorAndDegrees(_ tuples: (Color, Double)...) -> PointerInfoViewModels {
        return PointerInfoViewModels().withColorAndDegrees([]).withColorAndDegrees(tuples)
    }
}


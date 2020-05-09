import SwiftUI

/**
 # A tuple for color and degree of the pointer.
 */
final class PointerInfoViewModel {
    public let color: Color
    private let send: () -> ()
    
    var degrees: Double = 0.0 {
        didSet {
            self.send()
        }
    }
        
    init(
        color: Color,
        initDegrees: Double = 0.0,
        send: @escaping () -> ()
    ) {
        self.degrees = initDegrees
        self.color = color
        self.send = send
    }
}

final class PointerInfoViewModels: ObservableObject {
    @Published var pointerInfo: Array<PointerInfoViewModel>
    
    init() {
        self.pointerInfo = []
    }
    
    func withColorAndDegrees(_ tuples: (Color, Double)...) -> PointerInfoViewModels {
        self.pointerInfo = tuples.map { (color, initDegrees) in
            PointerInfoViewModel(
                color: color,
                initDegrees: initDegrees,
                send: { self.objectWillChange.send() }
            )
        }
        
        return self
    }
}


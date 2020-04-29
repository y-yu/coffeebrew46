/*
 # This app error interface.
 
 */
protocol CoffeeError: Error {
    var message: String { get }
    var cause: Error? { get }
}

struct CoffeeBeansWeightUnderZeroError: CoffeeError {
    var message: String = "The coffee beans weight must be greater than 0."
    var cause: Error?
    
    init(_ c: Error? = Optional.none) {
        self.cause = c
    }
}

struct CoffeeBeansWeightIsNotNumberError: CoffeeError {
    var message: String = "The coffee beans weight must be number."
    var cause: Error?
    
    init(_ c: Error? = Optional.none) {
        self.cause = c
    }
}

/*
 # This app error interface.
 */
enum CoffeeError: Error {
    case CoffeeBeansWeightUnderZeroError(Error?)
    
    case CoffeeBeansWeightIsNotNumberError(Error?)
    
    func getMessage() -> String {
        switch self {
        case .CoffeeBeansWeightUnderZeroError:
            return "The coffee beans weight must be greater than 0."
            
        case .CoffeeBeansWeightIsNotNumberError:
            return "The coffee beans weight must be number."
        }
    
    }
}

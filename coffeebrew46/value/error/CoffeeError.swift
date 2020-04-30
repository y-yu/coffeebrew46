/**
 # This app error interface.
 */
enum CoffeeError: Error {
    case CoffeeBeansWeightUnderZeroError
    
    case CoffeeBeansWeightIsNotNumberError
    
    case BoiledWaterAmountIsTooLessError
    
    case FirstShotBoiledWaterAmountExceededWholeAmountError
    
    case ShotTimesNumberIsNeededAtLeastOne
    
    func getMessage() -> String {
        switch self {
        case .CoffeeBeansWeightUnderZeroError:
            return "The coffee beans weight must be greater than 0."
            
        case .CoffeeBeansWeightIsNotNumberError:
            return "The coffee beans weight must be number."
            
        case .BoiledWaterAmountIsTooLessError:
            return "The boiled water need its amount greater than 0cc."
            
        case .FirstShotBoiledWaterAmountExceededWholeAmountError:
            return "The first shot boiled water amount less than or equal whole water amount."
            
        case .ShotTimesNumberIsNeededAtLeastOne:
            return "The numeber of times of shots for 60% is needed at least one."
        }
    }
}

extension CoffeeError {
    func toFailureNel<A>() -> ResultNel<A, Self> {
        .failure(NonEmptyList(self))
    }
}

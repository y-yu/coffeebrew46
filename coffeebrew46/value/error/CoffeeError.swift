/**
 # This app error interface.
 */
enum CoffeeError: Error {
    case coffeeBeansWeightUnderZeroError
    
    case coffeeBeansWeightIsNotNumberError
    
    case waterAmountIsTooLessError
    
    case first40PercentWaterAmountExceededWholeWaterAmountError
    
    case partitionsCountOf6IsNeededAtLeastOne
    
    case steamingTimeIsTooMuchThanTotal
    
    case firstWaterPercentIsZeroError
    
    case loadedConfigIsNotCompatible
    
    case jsonError
    
    func getMessage() -> String {
        switch self {
        case .coffeeBeansWeightUnderZeroError:
            return "The coffee beans weight must be greater than 0."
            
        case .coffeeBeansWeightIsNotNumberError:
            return "The coffee beans weight must be number."
            
        case .waterAmountIsTooLessError:
            return "The boiled water need its amount greater than 0cc."
            
        case .first40PercentWaterAmountExceededWholeWaterAmountError:
            return "The first shot boiled water amount less than or equal whole water amount."
            
        case .partitionsCountOf6IsNeededAtLeastOne:
            return "The number of times of shots for 60% is needed at least one."
            
        case .steamingTimeIsTooMuchThanTotal:
            return "The streaming time must be less than total time."
            
        case .firstWaterPercentIsZeroError:
            return "The first water percent must be more than 0."
            
        case .loadedConfigIsNotCompatible:
            return "The loaded configuration is not compatible."
            
        case .jsonError:
            return "Something error was occurred in json serialize/deserialize."
        }
    }
}

extension CoffeeError {
    func toFailureNel<A>() -> ResultNel<A, Self> {
        .failure(NonEmptyList(self))
    }
}

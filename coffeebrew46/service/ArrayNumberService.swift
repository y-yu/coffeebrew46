import Foundation
import Factory

/**
 # ArrayNumber to/from `Double`
 
 This service the `Double` number for example `12.3` to/from `[1, 2, 3]` (we called this _ArrayNumber_)`.
 */
protocol ArrayNumberService {
    /**
     Minimum value that this service handles is `0.1`. The smaller value more than 0.05 would be rounding,
     for example since the input is `12.39` with `digit = 3` then the return value is `[1, 2, 4]`.
     */
    func fromDouble(digit: Int, from: Double) -> ResultNea<NonEmptyArray<Int>, CoffeeError>

    func toDouble(_ arrayNumber: NonEmptyArray<Int>) -> Double
    
    func toDoubleWithError(_ arrayNumber: [Int]) -> ResultNea<Double, CoffeeError>
}

class ArrayNumberServiceImpl: ArrayNumberService {
    func fromDouble(digit: Int, from: Double) -> ResultNea<NonEmptyArray<Int>, CoffeeError> {
        let value = roundCentesimal(from)
        
        if value > pow(10.0, Double(digit - 1)) {
            return .failure(NonEmptyArray(.arrayNumberConversionError("`from` must be less than 10 ** (`digit` - 1).")))
        } else if digit <= 0 {
            return .failure(NonEmptyArray(.arrayNumberConversionError("`digit` must be greater than 0.")))
        } else {
            let head: Int = Int(floor(value / pow(10.0, Double(digit - 2))))
            var tail: [Int] = []
            for index in 1..<digit {
                var arr = tail
                arr.insert(head, at: 0)

                tail += [Int(floor(value / pow(10.0, Double(digit - index - 2)))) - Int(
                    arr.enumerated().reduce(0.0) { (acc, arg) in
                        let (i, item) = arg
                        return acc + (Double(item) * pow(10.0, Double(index - i)))
                    }
                )]
            }
            return .success(NonEmptyArray(head: head, tail: tail))
        }
    }
    
    func toDouble(_ arrayNumber: NonEmptyArray<Int>) -> Double {
        var result: Double = 0.0
        
        for (i, item) in arrayNumber.toArray().enumerated() {
            result += Double(item) * pow(10.0, Double(arrayNumber.count() - (i + 2)))
        }
        
        return result
    }
    
    func toDoubleWithError(_ arrayNumber: [Int]) -> ResultNea<Double, CoffeeError> {
        if let head = arrayNumber.first {
            .success(toDouble(NonEmptyArray(head: head, tail: Array(arrayNumber[1...]))))
        } else {
            .failure(NonEmptyArray(.arrayNumberConversionError("`arrayNumber` must not be empty.")))
        }
    }
}

extension Container {
    var arrayNumberService: Factory<ArrayNumberService> {
        Factory(self) { ArrayNumberServiceImpl() }
    }
}

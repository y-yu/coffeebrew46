import Foundation

/// # Floating number representation using tuple
///
/// `decimal` is always positive value.
public struct TupleFloat {
    let integer: Int
    let decimal: Int
    let digit: Int
}

extension TupleFloat {
    /// For example the input `from` is `12.39` and `digit = 1` then the return value is `TupleFloat(12, 4)`,
    /// and `digit = 2` then the return value is `TupleFloat(12, 39)`
    static func fromDouble(_ digit: Int, _ from: Double) -> ResultNea<TupleFloat, CoffeeError> {
        if digit < 0 {
            return .failure(NonEmptyArray(.arrayNumberConversionError("`digit` must be greater than 0.")))
        } else {
            let base = pow(10.0, Double(digit))
            let value = round(from * base) / base
            // `valueInt` must be always smaller than `value` so the `if` condition is needed.
            let valueInt = if value < 0 { ceil(value) } else { floor(value) }
            let valueDecimal = if value < 0 { valueInt - value } else { value - valueInt }

            return .success(TupleFloat(integer: Int(valueInt), decimal: Int(valueDecimal * base), digit: digit))
        }
    }

    func toDouble() -> Double {
        let base = pow(10.0, Double(digit))

        return if integer < 0 { Double(integer) - (Double(decimal) / base) } else { Double(integer) + (Double(decimal) / base) }
    }
}

extension TupleFloat: Equatable {
    static public func == (lhs: TupleFloat, rhs: TupleFloat) -> Bool {
        return lhs.integer == rhs.integer && lhs.decimal == rhs.decimal && lhs.digit == rhs.digit
    }
}

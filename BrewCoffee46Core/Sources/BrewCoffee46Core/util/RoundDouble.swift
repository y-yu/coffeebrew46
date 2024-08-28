import Foundation

/// Rounding `Double` value by `1/100` so for example `0.15` will be converting to `0.2`.
public func roundCentesimal(_ value: Double) -> Double {
    round(value * 10.0) / 10.0
}

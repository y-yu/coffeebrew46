import BrewCoffee46Core
import Foundation
import SwiftJWT

struct ConfigClaims: Claims, Equatable, Sendable {
    let iss: String
    let iat: Date
    let version: Int
    let config: Config
}

import BrewCoffee46Core
import Foundation
import SwiftJWT

struct ConfigClaims: Claims {
    let iss: String
    let iat: Date
    let version: Int
    let config: Config
}

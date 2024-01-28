import Foundation
import Factory

protocol UserDefaultsService {
    func setEncodable<A: Encodable>(_ value: A, forKey defaultName: String) -> ResultNel<Void, CoffeeError>
    
    func getDecodable<A: Decodable>(forKey: String) -> ResultNel<A?, CoffeeError>
}

class UserDefaultsServiceImpl: UserDefaultsService {
    func setEncodable<A: Encodable>(_ value: A, forKey: String) -> ResultNel<Void, CoffeeError> {
        let encoder = JSONEncoder()
        do {
            let json = try String(data: encoder.encode(value), encoding: .utf8)!
            UserDefaults.standard.set(json, forKey: forKey)
            return .success(())
        } catch {
            return .failure(NonEmptyList(CoffeeError.jsonError(error)))
        }
    }
    
    func getDecodable<A: Decodable>(forKey: String) -> ResultNel<A?, CoffeeError>  {
        let decoder = JSONDecoder()
        
        if let json = UserDefaults.standard.string(forKey: forKey)?.data(using: .utf8) {
            do {
                return .success(try decoder.decode(A.self, from: json))
            } catch {
                return .failure(NonEmptyList(CoffeeError.jsonError(error)))
            }
        } else {
            return .success(.none)
        }
    }
}

extension Container {
    var userDefaultsService: Factory<UserDefaultsService> {
        Factory(self) { UserDefaultsServiceImpl() }
    }
}

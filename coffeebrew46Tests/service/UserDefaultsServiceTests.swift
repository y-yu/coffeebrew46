import XCTest

@testable import CoffeeBrew46

struct Dummy: Equatable {
    let a: Int
    let b: Bool
    let c: String
    
    enum CodingKeys: String, CodingKey {
        case a
        case b
        case c
    }
}

extension Dummy: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        a = try values.decode(Int.self, forKey: .a)
        b = try values.decode(Bool.self, forKey: .b)
        c = try values.decode(String.self, forKey: .c)
    }
}

extension Dummy: Encodable {
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(a, forKey: .a)
        try container.encode(b, forKey: .b)
        try container.encode(c, forKey: .c)
    }
}

final class UserDefaultsServiceTests: XCTestCase {
    let key = "dummy"
    let sut = UserDefaultsServiceImpl()
    
    override func tearDown() {
        super.tearDown()
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    func test_set_and_get_dummy_data() throws {
        let dummy = Dummy(a: 1, b: true, c: "test")
            
        let actual1 = sut.setEncodable(dummy, forKey: key)
        XCTAssert(actual1.isSuccess())
        
        let actual2: CoffeeBrew46.ResultNea<Dummy?, CoffeeBrew46.CoffeeError> = sut.getDecodable(forKey: key)
        XCTAssertEqual(actual2, .success(.some(dummy)))
    }
    
    func test_return_none_if_there_is_no_data() throws {
        let actual: CoffeeBrew46.ResultNea<Dummy?, CoffeeBrew46.CoffeeError> = sut.getDecodable(forKey: key)
        XCTAssertEqual(actual, .success(.none))
    }
}

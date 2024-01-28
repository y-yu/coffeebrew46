import Foundation
import Factory

protocol DateService {
    func now() -> Date
}

class DateServiceImpl: DateService {
    func now() -> Date {
        Date.now
    }
}

extension Container {
    var dateService: Factory<DateService> {
        Factory(self) { DateServiceImpl() }
    }
}

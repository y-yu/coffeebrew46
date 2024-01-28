import UIKit
import StoreKit
import Factory

protocol RequestReviewService {
    func check() -> ResultNel<Bool, CoffeeError>
}

class RequestReviewServiceImpl: RequestReviewService {
    private let requestReviewInfoKey: String = "requestReviewInfo"
    
    private let requestReviewGuardKey: String = "requestReviewGuard"
    
    private let delta: Double = Double(100 * 24 * 60 * 60) // 100 days
    
    private let waiting: Double = 1.0 // second
    
    private let minimumTryCount: Int = 3
    
    func check() -> ResultNel<Bool, CoffeeError> {
        beforeCheck().flatMap { result in
            if result {
                requestReview()
            } else {
                .success(false)
            }
        }
    }
    
    private func saveInitGuard() -> ResultNel<Void, CoffeeError> {
        RequestReviewGuard(tryCount: 1).toJSON(isPrettyPrint: false).map { json in
            UserDefaults.standard.set(json, forKey: requestReviewGuardKey)
        }
    }
    
    private func beforeCheck() -> ResultNel<Bool, CoffeeError> {
        if let requestReviewGuardJson = UserDefaults.standard.string(forKey: requestReviewGuardKey) {
            RequestReviewGuard.fromJSON(requestReviewGuardJson).flatMap { requestReviewGuard in
                RequestReviewGuard(tryCount: requestReviewGuard.tryCount + 1).toJSON(isPrettyPrint: false).map { json in
                    UserDefaults.standard.set(json, forKey: requestReviewGuardKey)
                    return requestReviewGuard.tryCount >= minimumTryCount
                }
            }
            .flatMapError { _ in
                saveInitGuard().map { _ in false }
            }
        } else {
            saveInitGuard().map { _ in false }
        }
    }
    
    private func requestReview() -> ResultNel<Bool, CoffeeError> {
        let now = Date.now
        let appVersion: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!
        let requestReviewItem = RequestReviewItem(appVersion: appVersion, requestedDate: now)
        
        if let requestReviewInfoJson = UserDefaults.standard.string(forKey: requestReviewInfoKey) {
            return RequestReviewInfo.fromJSON(requestReviewInfoJson).flatMap { requestReviewInfo in
                if !requestReviewInfo.requestHistory.isEmpty {
                    let latest = requestReviewInfo.requestHistory.last!
                    
                    if now.timeIntervalSince(latest.requestedDate) >= delta {
                        let updatedRequestReviewInfo = RequestReviewInfo(requestHistory: requestReviewInfo.requestHistory + [requestReviewItem])
                        
                        return updatedRequestReviewInfo.toJSON(isPrettyPrint: false).map { json in
                            UserDefaults.standard.set(json, forKey: requestReviewInfoKey)
                            return true
                        }
                    } else {
                        return .success(false) as ResultNel<Bool, CoffeeError>
                    }
                } else {
                    let updatedRequestReviewInfo = RequestReviewInfo(requestHistory: [requestReviewItem])
                    return updatedRequestReviewInfo.toJSON(isPrettyPrint: false).map { json in
                        UserDefaults.standard.set(json, forKey: requestReviewInfoKey)
                        return false
                    }
                }
            }
        } else {
            let updatedRequestReviewInfo = RequestReviewInfo(requestHistory: [requestReviewItem])
            return updatedRequestReviewInfo.toJSON(isPrettyPrint: false).map { json in
                UserDefaults.standard.set(json, forKey: requestReviewInfoKey)
                return false
            }
        }
    }
}

extension Container {
    var requestReviewService: Factory<RequestReviewService> {
        Factory(self) { RequestReviewServiceImpl() }
    }
}

import UIKit
import StoreKit
import Factory

protocol RequestReviewService {
    func show() -> Void
}

class RequestReviewServiceImpl: RequestReviewService {
    private let userDefaultKey: String = "requestReviewInfo"
    
    private let delta: Double = Double(100 * 24 * 60 * 60) // 100 days
    
    private let waiting: Double = 1.0 // second
    
    func show() -> Void {
        let now = Date.now
        let appVersion: String = (Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String)!
        
        let requestReviewItem = RequestReviewItem(appVersion: appVersion, requestedDate: now)
        
        if let requestReviewInfoJson = UserDefaults.standard.string(forKey: userDefaultKey) {
            let requestReviewInfoResult = RequestReviewInfo.fromJSON(requestReviewInfoJson)
            requestReviewInfoResult.forEach { requestReviewInfo in
                if !requestReviewInfo.requestHistory.isEmpty {
                    let latest = requestReviewInfo.requestHistory.last!
                    
                    if now.timeIntervalSince(latest.requestedDate) >= delta {
                        let updatedRequestReviewInfo = RequestReviewInfo(requestHistory: requestReviewInfo.requestHistory + [requestReviewItem])
                        
                        updatedRequestReviewInfo.toJSON(isPrettyPrint: false).forEach { json in
                            UserDefaults.standard.set(json, forKey: userDefaultKey)
                            DispatchQueue.main.asyncAfter(deadline: .now() + waiting) {
                                let scenes = UIApplication.shared.connectedScenes
                                if let windowScene = scenes.first as? UIWindowScene {
                                    SKStoreReviewController.requestReview(in: windowScene)
                                }
                            }
                        }
                    }
                }
            }
        } else {
            let updatedRequestReviewInfo = RequestReviewInfo(requestHistory: [requestReviewItem])
            updatedRequestReviewInfo.toJSON(isPrettyPrint: false).forEach { json in
                UserDefaults.standard.set(json,  forKey: userDefaultKey)
    
                DispatchQueue.main.asyncAfter(deadline: .now() + waiting) {
                    let scenes = UIApplication.shared.connectedScenes
                    if let windowScene = scenes.first as? UIWindowScene {
                        SKStoreReviewController.requestReview(in: windowScene)
                    }
                }
            }
        }
    }
}

extension Container {
    var requestReviewService: Factory<RequestReviewService> {
        Factory(self) { RequestReviewServiceImpl() }
    }
}

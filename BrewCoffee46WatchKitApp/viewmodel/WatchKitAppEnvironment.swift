import Foundation
import SwiftUI

final class WatchKitAppEnvironment: ObservableObject {
    @Published var rootPath: [Route] = []
}

import SwiftUI

struct SaveLoadView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel
    
    private let dataCount: Int = 10
    
    var body: some View {
        Form {
            ForEach(0..<dataCount) { i in
                HStack {
                    
                }
            }
        }
        .navigationTitle("Save & Load")
    }
}

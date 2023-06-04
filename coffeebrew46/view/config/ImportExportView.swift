import SwiftUI

struct ImportExportView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
        
    @State var json: String = ""
    @State var isPrettyPrint: Bool = true
    
    var body: some View {
        Form {
            Toggle("JSON pretty printing", isOn: $isPrettyPrint)
            Section(header: Text("JSON")) {
                HStack {
                    Spacer()
                    Button(action: {
                        updateConfig()
                    }){
                        HStack {
                            Spacer()
                            Text("Import")
                            Spacer()
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    .disabled(appEnvironment.isTimerStarted)
                    .id(!appEnvironment.isTimerStarted)
        
                    Divider()

                    Button(action: {
                        exportJSON()
                    }){
                        HStack {
                            Spacer()
                            Text("Export")
                            Spacer()
                        }
                    }
                    .buttonStyle(BorderlessButtonStyle())
                    Spacer()
                }
            }
            Section(header: Text("Output")) {
                TextEditor(text: $json)
                    .frame(maxHeight: .infinity)
            }
            Section(header: Text("Log")) {
                Text(viewModel.errors)
                    .foregroundColor(.red)
                    .hidden(viewModel.errors == "")
            }
        }
        .navigationTitle("Import & Export")
    }
    
    private func updateConfig() {
        viewModel.errors = ""
        switch Config.fromJSON(json) {
        case .success(let config):
            viewModel.currentConfig = config
        case .failure(let errors):
            viewModel.errors = "\(errors)"
        }
    }
    
    private func exportJSON() {
        viewModel.errors = ""
        switch viewModel.currentConfig.toJSON(isPrettyPrint: isPrettyPrint) {
        case .success(let j):
            json = j
        case .failure(let errors):
            viewModel.errors = "\(errors)"
        }
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

#if DEBUG
struct SaveLoadView_Previews: PreviewProvider {
    static var previews: some View {
        ImportExportView()
            .environmentObject(
                CurrentConfigViewModel.init(
                    validateInputService: ValidateInputServiceImpl(),
                    calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
                )
            )
            .environmentObject(AppEnvironment.init())
    }
}
#endif

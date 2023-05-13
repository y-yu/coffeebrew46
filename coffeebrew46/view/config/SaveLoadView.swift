import SwiftUI

struct SaveLoadView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel
        
    @State var json: String = ""
    @State var isPrettyPrint: Bool = true
    
    var body: some View {
        Form {
            Toggle("JSON pretty printing", isOn: $isPrettyPrint)
            Section {
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
            Section(header: Text("JSON")) {
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
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        do {
            try viewModel.currentConfig = decoder.decode(Config.self, from: jsonData)
        } catch {
            viewModel.errors = "\(error)"
        }
    }
    
    private func exportJSON() {
        viewModel.errors = ""
        let encoder = JSONEncoder()
        if isPrettyPrint {
            encoder.outputFormatting = .prettyPrinted
        }
        do {
            json = try String(data: encoder.encode(viewModel.currentConfig), encoding: .utf8)!
        } catch {
            viewModel.errors = "\(error)"
        }
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

struct SaveLoadView_Previews: PreviewProvider {
    static var previews: some View {
        SaveLoadView()
            .environmentObject(
                CurrentConfigViewModel.init(
                    validateInputService: ValidateInputServiceImpl(),
                    calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl()
                )
            )
            .environmentObject(AppEnvironment.init())
    }
}

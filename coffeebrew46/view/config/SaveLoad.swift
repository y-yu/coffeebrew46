import SwiftUI

struct SaveLoadView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel
        
    @State var json: String = ""
    @State var errorMessage: String = ""
    
    var body: some View {
        Form {
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
            Section(header: Text("Error")) {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .hidden(errorMessage == "")
            }
        }
        .navigationTitle("Import & Export")
    }
    
    private func updateConfig() {
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        do {
            try viewModel.currentConfig = decoder.decode(Config.self, from: jsonData)
            errorMessage = ""
        } catch {
            errorMessage = "\(error)"
        }
    }
    
    private func exportJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        json = try! String(data: encoder.encode(viewModel.currentConfig), encoding: .utf8)!
        errorMessage = ""
    }
}

extension View {
    func hidden(_ shouldHide: Bool) -> some View {
        opacity(shouldHide ? 0 : 1)
    }
}

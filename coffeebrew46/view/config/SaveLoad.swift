import SwiftUI

struct SaveLoadView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: ContentViewModel
        
    @State var json: String = ""
    
    var body: some View {
        GeometryReader { geometory in
            Form {
                Section {
                    Button(action: {
                        exportJSON()
                    }){
                        Text("Export")
                    }
                }
                Section{
                    Button(action: {
                        updateConfig()
                    }){
                        Text("Import")
                    }
                }
                TextEditor(text: $json)
                    .frame(maxHeight: geometory.size.height)
            }
        }
        .navigationTitle("Save & Load")
    }
    
    private func updateConfig() {
        let decoder = JSONDecoder()
        let jsonData = json.data(using: .utf8)!
        let config = try! decoder.decode(Config.self, from: jsonData)
        viewModel.currentConfig = config
    }
    
    private func exportJSON() {
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        json = try! String(data: encoder.encode(viewModel.currentConfig), encoding: .utf8)!
    }
}

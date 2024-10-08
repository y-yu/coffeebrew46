import BrewCoffee46Core
import SwiftUI

struct ImportExportView: View {
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
                    }) {
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
                    }) {
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
            Section(
                header: HStack {
                    Text("Log")
                    Spacer()
                    Button(
                        role: .destructive,
                        action: {
                            viewModel.errors = ""
                        }
                    ) {
                        Text("config import export clear log")
                    }
                    .disabled(viewModel.errors == "")
                }
            ) {
                Text(viewModel.errors)
                    .foregroundColor(.red)
                    .hidden(viewModel.errors == "")
            }
        }
        .navigationTitle("config import export")
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
    struct ImportExportView_Previews: PreviewProvider {
        static var previews: some View {
            ImportExportView()
                .environmentObject(CurrentConfigViewModel.init())
                .environmentObject(AppEnvironment.init())
        }
    }
#endif

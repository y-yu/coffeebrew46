import BrewCoffee46Core
import Factory
import SwiftUI

struct UniversalLinksImportView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    @Injected(\.saveLoadConfigService) private var saveLoadConfigService: SaveLoadConfigService

    @State var json: String = ""
    @State var isShowJson: Bool = false

    var body: some View {
        Form {
            if let importedConfig = appEnvironment.importedConfig {
                Section(header: Text("config import imported config")) {
                    ShowConfigView(
                        config: Binding(
                            get: { importedConfig.config },
                            set: { _ in () }
                        ),
                        isLock: true.getOnlyBinding
                    )

                    HStack {
                        Spacer()
                        Button(action: {
                            saveLoadConfigService
                                .saveConfig(config: importedConfig.config)
                                .recoverWithErrorLog(&viewModel.errors)
                        }) {
                            HStack {
                                Text("config save button")
                                Image(systemName: "plus.square.on.square")
                            }
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 10, style: .continuous)
                                    .stroke(lineWidth: 1)
                                    .padding(6)
                            )
                        }
                    }
                }

                Toggle("config import is JSON show", isOn: $isShowJson)
                    .onChange(of: isShowJson) {
                        exportJSON(importedConfig.config)
                    }

                if isShowJson {
                    Section(header: Text("JSON")) {
                        TextEditor(text: $json)
                            .frame(maxHeight: .infinity)
                    }
                }
            } else {
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
        }
        .navigationTitle("config universal links")
    }

    private func exportJSON(_ config: Config) {
        viewModel.errors = ""
        switch config.toJSON(isPrettyPrint: true) {
        case .success(let j):
            json = j
        case .failure(let errors):
            viewModel.errors = "\(errors)"
        }
    }
}

#if DEBUG
    struct UniversalLinksImportView_Previews: PreviewProvider {
        static var previews: some View {
            UniversalLinksImportView()
                .environmentObject(CurrentConfigViewModel.init())
                .environmentObject(
                    { () in
                        let env = AppEnvironment.init()
                        env.importedConfig = ConfigClaims(iss: "dummy", iat: Date.now, version: 1, config: Config.defaultValue)

                        return env
                    }()
                )
                .previewDisplayName("importedConfig is `some`")
        }
    }
#endif

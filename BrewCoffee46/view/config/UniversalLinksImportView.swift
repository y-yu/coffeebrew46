import BrewCoffee46Core
import Factory
import SwiftUI

struct UniversalLinksImportView: View {
    @EnvironmentObject var appEnvironment: AppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    @Injected(\.saveLoadConfigService) private var saveLoadConfigService: SaveLoadConfigService

    @State var json: String = ""
    @State var isShowJson: Bool = false
    @State var hasDoneImport: Bool = false

    var body: some View {
        Form {
            if var importedConfig = appEnvironment.importedConfigClaims?.config {
                Section(header: Text("config universal links import imported config")) {
                    ShowConfigView(
                        config: Binding(
                            get: { importedConfig },
                            set: { config in importedConfig = config }
                        ),
                        isLock: false.getOnlyBinding
                    )

                    HStack {
                        Spacer()
                        Button(action: {
                            saveLoadConfigService
                                .saveConfig(config: importedConfig)
                                .map { x in
                                    hasDoneImport = true
                                    return x
                                }
                                .recoverWithErrorLog(&viewModel.errors)
                        }) {
                            HStack {
                                Text("config universal links import save button")
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

                Toggle("config universal links import is JSON show", isOn: $isShowJson)
                    .onChange(of: isShowJson) {
                        exportJSON(importedConfig)
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
                            Text("config universal links import export clear log")
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
        .sheet(isPresented: $hasDoneImport) {
            Button(action: {
                hasDoneImport = false
                appEnvironment.importedConfigClaims = .none
                appEnvironment.configPath.append(.saveLoad)
            }) {
                VStack {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.green)
                        Text("config universal links import is done")
                            .font(.system(size: 30))
                    }
                    Text("config universal links import move to save & load")
                }
            }
            .presentationDetents([
                .medium,
                .fraction(0.3),
            ])
        }
        .navigationTitle("config universal links import title")
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
                        env.importedConfigClaims = ConfigClaims(iss: "dummy", iat: Date.now, version: 1, config: Config.defaultValue())

                        return env
                    }()
                )
                .previewDisplayName("importedConfig is `some`")
        }
    }
#endif

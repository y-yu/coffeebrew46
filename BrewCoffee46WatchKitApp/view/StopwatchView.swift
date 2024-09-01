import BrewCoffee46Core
import Foundation
import SwiftUI

struct StopwatchView: View {
    @EnvironmentObject var appEnvironment: WatchKitAppEnvironment
    @EnvironmentObject var viewModel: CurrentConfigViewModel

    @State var startAt: Date? = .none

    private let countDownInit: Double = 3.0

    var body: some View {
        VStack {
            if let startAt {
                TimelineView(.periodic(from: startAt, by: interval)) { timeline in
                    let progressTime: Double = timeline.date.timeIntervalSince(startAt) - countDownInit
                    let currentPhase: Int =
                        viewModel.dripInfo.getNthPhase(
                            progressTime: progressTime,
                            totalTimeSec: viewModel.currentConfig.totalTimeSec
                        )
                    VStack {
                        if progressTime >= 0 {
                            progressView(
                                currentPhase: currentPhase,
                                totalDripCount: viewModel.dripInfo.dripTimings.count,
                                progressTime: progressTime
                            )
                        } else {
                            VStack {
                                showDripInfo(index: 0, totalDripCount: viewModel.dripInfo.dripTimings.count)
                                ProgressView(value: abs(progressTime) / countDownInit)
                                    .tint(.green)
                            }

                        }
                        Spacer()
                        HStack {
                            Spacer()
                            Text(String(format: "%.1f ", progressTime))
                                .font(Font(UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)))
                                .fixedSize()
                                .frame(alignment: .bottom)
                                .foregroundColor(
                                    progressTime < viewModel.currentConfig.totalTimeSec ? .primary : .red
                                )
                            Spacer()
                            Text(String(format: "/ %3.0f sec", viewModel.currentConfig.totalTimeSec))
                                .font(Font(UIFont.monospacedSystemFont(ofSize: 16, weight: .regular)))
                                .fixedSize()
                                .frame(alignment: .bottom)
                        }
                        Spacer()
                        Button(action: {
                            self.startAt = .none
                        }) {
                            Text("Stop")
                        }
                    }
                }
            } else {
                VStack {
                    progressView(
                        currentPhase: -1,  // It means that the stopwatch has not started yet.
                        totalDripCount: viewModel.dripInfo.dripTimings.count,
                        progressTime: -countDownInit
                    )
                    Button(action: {
                        self.startAt = Date.now
                    }) {
                        Text("Start")
                    }
                }
            }
        }
        .navigationTitle("navigation title stopwatch")
    }

    private func showDripInfo(index: Int, totalDripCount: Int) -> some View {
        HStack {
            switch index {
            case 0:
                Text(String(format: NSLocalizedString("watch kit app 1st drip", comment: ""), totalDripCount))
            case 1:
                Text(String(format: NSLocalizedString("watch kit app 2nd drip", comment: ""), totalDripCount))
            case 2:
                Text(String(format: NSLocalizedString("watch kit app 3rd drip", comment: ""), totalDripCount))
            default:
                Text(String(format: NSLocalizedString("watch kit app after 4th drip suffix", comment: ""), index + 1, totalDripCount))
            }
            Spacer()
            Text(
                "\(String(format: "%.1f", roundCentesimal(viewModel.dripInfo.dripTimings[index].waterAmount)))\(weightUnit)"
            )
        }
    }

    private func progressView(
        currentPhase: Int,
        totalDripCount: Int,
        progressTime: Double
    ) -> some View {
        ScrollView {
            LazyVStack {
                ForEach(Array(viewModel.dripInfo.dripTimings.enumerated()), id: \.offset) { index, dripTiming in
                    VStack {
                        showDripInfo(index: index, totalDripCount: totalDripCount)
                        if index == currentPhase {
                            if index == totalDripCount - 1 {
                                ProgressView(
                                    value: (progressTime - viewModel.dripInfo.dripTimings[index].dripAt)
                                        / (viewModel.currentConfig.totalTimeSec - viewModel.dripInfo.dripTimings[index].dripAt)
                                )
                                .tint(.blue)
                            } else {
                                ProgressView(
                                    value: (progressTime - viewModel.dripInfo.dripTimings[index].dripAt)
                                        / (viewModel.dripInfo.dripTimings[index + 1].dripAt - viewModel.dripInfo.dripTimings[index].dripAt)
                                )
                                .tint(.blue)
                            }
                        } else if index > currentPhase {
                            ProgressView(value: 0.0).tint(.blue)
                        } else {
                            ProgressView(value: 1.0).tint(.green)
                        }
                    }
                    .id(index)
                }
            }
            .scrollTargetLayout()
        }
        .scrollPosition(
            id: Binding(
                get: { currentPhase },
                set: { _ in () }
            ))
    }
}

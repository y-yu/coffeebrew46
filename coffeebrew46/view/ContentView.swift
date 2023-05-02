import SwiftUI

struct ContentView: View {
    @ObservedObject var viewModel: ContentViewModel
    
    @State private var progressTime = 0
    @State private var timer: Timer?
    
    @State private var totalTime: Double = 210
    @State private var steamingTime: Double = 55
    
    var body: some View {
        ScrollView([.vertical, .horizontal]) {
            VStack {
                Text("Coffee beans weight: \(String(format: "%.1f", viewModel.coffeeBeansWeight))g")
                
                HStack {
                    Spacer()
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if (viewModel.coffeeBeansWeight > 0) {
                                viewModel.coffeeBeansWeight -= 0.1
                            }
                        }
                    Spacer()
                    Slider(value: $viewModel.coffeeBeansWeight, in: 0...50, step: 0.5)
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if (viewModel.coffeeBeansWeight < 50) {
                                viewModel.coffeeBeansWeight += 0.1
                            }
                        }
                    Spacer()
                }
                
                Text("The first warter percent of 40%: \(String(format: "%.2f", viewModel.firstBoiledWaterPercent))")
                HStack {
                    Spacer()
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if (viewModel.firstBoiledWaterPercent > 0) {
                                viewModel.firstBoiledWaterPercent -= 0.05
                            }
                        }
                    Spacer()
                    Slider(
                        value: $viewModel.firstBoiledWaterPercent,
                        in: 0...1,
                        step: 0.1
                    )
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if (viewModel.firstBoiledWaterPercent < 1) {
                                viewModel.firstBoiledWaterPercent += 0.05
                            }
                        }
                    Spacer()
                }
                
                Text("The number of partitions of 60%")
                HStack {
                    Spacer()
                    Image(systemName: "minus.circle")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if (viewModel.numberOf6 > 1) {
                                viewModel.numberOf6 -= 1
                            }
                        }
                    Spacer()
                    Text(String(format: "%1.0f", viewModel.numberOf6))
                        .font(.system(size: 40))
                    Spacer()
                    Image(systemName: "plus.circle")
                        .resizable()
                        .frame(width: 40, height: 40, alignment: .center)
                        .onTapGesture {
                            if (viewModel.numberOf6 < 6) {
                                viewModel.numberOf6 += 1
                            }
                        }
                    Spacer()
                }
                
                ScaleView(
                    scaleMax: $viewModel.totalWaterAmount,
                    pointerInfoViewModels: $viewModel.pointerInfoViewModels,
                    progressTime: $progressTime,
                    steamingTime: steamingTime,
                    totalTime: totalTime
                )
                .frame(width: 300, height: 300)
                
                HStack {
                    Spacer()
                    Text("Start")
                        .font(.system(size: 20))
                        .padding()
                        .background(
                            Rectangle()
                                .stroke(lineWidth: 4)
                                .padding(6)
                        )
                        .onTapGesture {
                            if (self.timer == nil) {
                                self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {_ in
                                    progressTime += 1
                                }
                            }
                        }
                    Spacer()
                    Text("\(String(format: "%d", progressTime))")
                        .font(.system(size: 40))
                        .fixedSize()
                        .frame(width: 100, height: 40)
                    Text(" sec")
                    Spacer()
                    Text("Stop")
                        .font(.system(size: 20))
                        .padding()
                        .background(
                            Rectangle()
                                .stroke(lineWidth: 4)
                                .padding(6)
                        )
                        .onTapGesture {
                            if let t = self.timer {
                                t.invalidate()
                                progressTime = 0
                                self.timer = .none
                            }
                        }
                    Spacer()
                    
                }
                VStack {
                    Text("Total time: \(String(format: "%.2f", totalTime))")
                    HStack {
                        Spacer()
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .onTapGesture {
                                if (totalTime > 1) {
                                    totalTime -= 1
                                }
                            }
                        Spacer()
                        Slider(
                            value: $totalTime,
                            in: 1...300,
                            step: 1
                        )
                        Spacer()
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .onTapGesture {
                                if (totalTime < 300) {
                                    totalTime += 1
                                }
                            }
                        Spacer()
                    }
                    Text("Steaming time: \(String(format: "%.2f", steamingTime))")
                    HStack {
                        Spacer()
                        Image(systemName: "minus.circle")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .onTapGesture {
                                if (steamingTime > totalTime / (viewModel.numberOf6 + 2)) {
                                    steamingTime -= 1
                                }
                            }
                        Spacer()
                        Slider(
                            value: $steamingTime,
                            in: 1...((totalTime / (viewModel.numberOf6 + 2)) * 2),
                            step: 1
                        )
                        Spacer()
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 40, height: 40, alignment: .center)
                            .onTapGesture {
                                if (steamingTime < (totalTime / (viewModel.numberOf6 + 2)) * 2) {
                                    steamingTime += 1
                                }
                            }
                        Spacer()
                    }
                    
                }
                /*
                 ForEach(
                 0 ..< viewModel.pointerInfoViewModels.pointerInfo.count,
                 id: \.self
                 ) { i in
                 Text("The \(i + 1)th water wegiht: \(String(format: "%.1f", self.viewModel.totalWaterAmount * self.viewModel.pointerInfoViewModels.pointerInfo[i].degrees / 360))")
                 }
                 */
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(
            viewModel: ContentViewModel(
                calculateBoiledWaterAmountService: CalculateBoiledWaterAmountServiceImpl(
                    validateInputService: ValidateInputServiceImpl()
                )
            )
        )
    }
}

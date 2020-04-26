//
//  ContentViewModel.swift
//  coffeebrew46
//
//  Created by nanashiki on 2020/04/26.
//  Copyright © 2020 吉村優. All rights reserved.
//

import SwiftUI

final class ContentViewModel: ObservableObject {
    @Published var textInput = "" {
           didSet {
               calc()
           }
       }

    @Published private(set) var weight = 0.0
    @Published private(set) var boiledWaterAmountText = ""
    
    // For DI
    private let curriculateBoiledWaterAmountService: CurriculateBoiledWaterAmountService
    
    // This model makes UI. I need to execute the business logic in this.
    // So I designed this constructor to be able to inject the dependecies
    // which are required to do my business logic.
    init(
        curriculateBoiledWaterAmountService: CurriculateBoiledWaterAmountService
    ) {
        self.curriculateBoiledWaterAmountService = curriculateBoiledWaterAmountService
    }
    
    func calc() {
        // Convert input text to Double
        guard let weight = Double(textInput) else {
            boiledWaterAmountText = "The coffee beans weight must be number."
            return
        }
        
        // Binding weight
        self.weight = weight
        
        // Calc and binding boiledWaterAmountText
        boiledWaterAmountText = curriculateBoiledWaterAmountService
            .curriculate(
                coffeeBeansWeight: weight,
                // This is a sloppy impletementation!!!!!!!!!!!!!!
                // TODO: Fix it
                firstBoiledWaterAmount: weight / 2,
                numberOf6: 3
            )
            .fold(
                ifLeft: { (coffeeError) -> String in
                    return coffeeError.message
                },
                ifRight: { (boiledWaterAmount) -> String in
                    return "Boiled water amounts are \(boiledWaterAmount.toString())"
                }
            )
    }
}

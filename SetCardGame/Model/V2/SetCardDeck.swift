//
//  SetCardDeck.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 11/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import Foundation

struct SetCardDeck {
    private(set) var cards = [SetCard]()
    
    init () {
        for number in SetCard.Variant.allCases {
            for color in SetCard.Variant.allCases {
                for shape in SetCard.Variant.allCases {
                    for fill in SetCard.Variant.allCases {
                        cards.append(SetCard(number: number, color: color, shape: shape, fill: fill))
                    }
                }
            }
        }
    }
    
    mutating func draw() -> SetCard? {
        if cards.count > 0 {
            return cards.remove(at: Int.random(in: 0..<cards.count))
        } else {
            return nil
        }
    }
}

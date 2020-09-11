//
//  SetCard.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 11/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import Foundation

struct SetCard: Equatable, CustomStringConvertible {
    let number: Variant
    let color: Variant
    let shape: Variant
    let fill: Variant
    
    var description: String {return "\(number)-\(number)-\(number)-\(number)"}
    
    enum Variant: Int, CaseIterable, CustomStringConvertible {
        case v1 = 1
        case v2
        case v3
        
        var description: String {return String(self.rawValue)}
        var idx: Int {return (self.rawValue - 1)}
    }
    
    static func isSet(cards: [SetCard]) -> Bool {
        guard cards.count == 3 else {return false}
        let sum = [
            cards.reduce(0, { $0 + $1.number.rawValue}),
            cards.reduce(0, { $0 + $1.color.rawValue}),
            cards.reduce(0, { $0 + $1.shape.rawValue}),
            cards.reduce(0, { $0 + $1.fill.rawValue})
        ]
        return sum.reduce(true, { $0 && ($1 % 3 == 0)})
    }
}

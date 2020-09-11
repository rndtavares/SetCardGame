//
//  Card.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 15/07/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import Foundation

struct Card : Equatable {
    var shape: Shape
    var color: Color
    var shading: Shading
    var numberOfShapes: NumberOfShapes
    var selected = false
    var matched = false
    var mismatched = false
    var hided = false
}

enum Shape: String, CustomStringConvertible {
    case diamond = "▲"
    case squiggle = "■"
    case oval = "●"
    static var all = [Shape.diamond, .squiggle, .oval]
    var description: String { return rawValue}
}

enum Shading {
    case filled //NSAttributedString.Key.foregroundColor UIColor().withAlphaComponent 100%
    case striped //NSAttributedString.Key.foregroundColor UIColor().withAlphaComponent 15%
    case outline //NSAttributedString.Key.strokeWidth > 0
    static var all = [Shading.filled, .striped, .outline]
}

enum Color {
    case red
    case green
    case purple
    static var all = [Color.red, .green, .purple]
}

enum NumberOfShapes: Int {
    case one = 1
    case two = 2
    case three = 3
    static var all = [NumberOfShapes.one, .two, .three]
}

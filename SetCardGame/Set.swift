//
//  Set.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 23/07/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import Foundation

struct Set{
    private(set) var cards = [Card]()
    var deckCount: Int {return cards.count}
    
    private(set) var score = 0
    private(set) var flipCount = 0
    private(set) var numberSets = 0
    
    private(set) var cardsOnTable = [Card]()
    private(set) var cardsSelected = [Card]()
    private(set) var cardsTryMatched = [Card]()
    private(set) var cardsRemoved = [Card]()
    
    var qtdCardsGame = 12
    private var selectedCards = [Int]()
    private(set) var hasMatch = false
    
    var isSet: Bool? {
        get {
            guard cardsTryMatched.count == 3 else {return nil}
            return true
            // return Card.isSet(cards: cardsTryMatched)
        }
        set {
            if newValue != nil {
                if newValue! {
//                    score += Points.matchBonus
                    numberSets += 1
                } else {
//                    score -= Points.missMatchPenalty
                }
                cardsTryMatched = cardsSelected
                cardsSelected.removeAll()
            } else {
                cardsTryMatched.removeAll()
            }
        }
    }
    
    mutating func startGame(){
        cards.removeAll()
        score = 0
        qtdCardsGame = 12
        selectedCards.removeAll()
        hasMatch = false
        setDeck()
        shuffleCards()
    }
    
    mutating private func setDeck(){
        for shape in Shape.all{
            for color in Color.all{
                for shading in Shading.all{
                    for numberOfShapes in NumberOfShapes.all{
                        let card = Card(shape: shape, color: color, shading: shading, numberOfShapes: numberOfShapes, selected: false, matched: false, mismatched: false, hided: false)
                        cards.append(card)
                    }
                }
            }
        }
    }
    
    mutating func shuffleCards(){
        var shuflledCards = [Card]()
        while cards.count > 1 {
            shuflledCards.append(cards.remove(at: cards.count.arc4random))
        }
        cards += shuflledCards
    }
    
    mutating func chooseCard(at index: Int) {
        assert(cards.indices.contains(index), "SetGame.chooseCard(at: \(index)): chosen index not in the cards")
        checkReplacement()
        if !cards[index].matched {
            if selectedCards.contains(index){
                cards[index].selected = false
                selectedCards.remove(at: selectedCards.index(of: index)!)
            } else {
                cards[index].selected = true
                selectedCards.append(index)
            }
            
            if selectedCards.count == 3 {
                checkMatching()
            }
        }
    }
    
    mutating func checkReplacement() {
        if selectedCards.count == 3 {
            if hasMatch {
                for index in selectedCards {
                    if cards.count > qtdCardsGame{
                        cards.remove(at: index)
                        cards.insert(cards.popLast()!, at: index)
                    }else{
                        cards[index].hided = true
                    }
                }
                hasMatch = false
            } else {
                for index in selectedCards {
                    cards[index].selected = false
                    cards[index].mismatched = false
                }
            }
            selectedCards.removeAll()
        }
    }
    
    private mutating func checkMatching(){
        var colorArray = [Color]()
        var shadingArray = [Shading]()
        var shapeArray = [Shape]()
        var numberOfShapesArray = [NumberOfShapes]()
        for index in selectedCards {
            if !colorArray.contains(cards[index].color) {
                colorArray.append(cards[index].color)
            }
            if !shadingArray.contains(cards[index].shading) {
                shadingArray.append(cards[index].shading)
            }
            if !shapeArray.contains(cards[index].shape) {
                shapeArray.append(cards[index].shape)
            }
            if !numberOfShapesArray.contains(cards[index].numberOfShapes) {
                numberOfShapesArray.append(cards[index].numberOfShapes)
            }
        }
        if colorArray.count != 2 {
            score += 1
            hasMatch = true
        }
        if shadingArray.count != 2 {
            score += 1
            hasMatch = true
        }
        if shapeArray.count != 2 {
            score += 1
            hasMatch = true
        }
        if numberOfShapesArray.count != 2 {
            score += 1
            hasMatch = true
        }
        for index in selectedCards {
            if hasMatch {
                selectedCards = selectedCards.sorted { $0 > $1 }
                cards[index].matched = true
            } else {
                cards[index].mismatched = true
                score -= 1
            }
        }
    }
    
    init(){
        startGame()
    }
    
    mutating func draw() -> Card? {
        if cards.count > 0 {
            return cards.remove(at: cards.count.arc4random)
        } else {
            return nil
        }
    }
}

extension Int {
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}

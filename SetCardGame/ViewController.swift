//
//  ViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 15/07/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum BorderType {
        case selected
        case matched
        case mismatched
        case none
    }
    
    private var setGame = Set()

    @IBOutlet var cardButtons: [UIButton]!
    
    @IBOutlet weak var scoreLabel: UILabel! {
        didSet {
            updateScore()
        }
    }
    
    @IBOutlet weak var deal3MoreCardsButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        newGame()
    }

    @IBAction func touchCard(_ sender: UIButton) {
        if let cardNumber = cardButtons.index(of: sender) {
            if canSelect(cardNumber) {
                setGame.chooseCard(at: cardNumber)
                updateViewFromModel()
            } else {
                print("can't select this card")
            }
        } else {
            print("choosen card was not in cardButtons")
        }
    }
    
    @IBAction func deal3MoreCards(_ sender: UIButton) {
        if setGame.hasMatch {
            setGame.checkReplacement()
        } else {
            setGame.qtdCardsGame += 3
        }
        updateViewFromModel()
    }
    
    @IBAction func newGame(_ sender: UIButton) {
        newGame()
    }
    
    private func newGame(){
        setGame.startGame()
        updateViewFromModel()
    }
    
    private func canSelect(_ cardNumber: Int) -> Bool{
        if setGame.cards[cardNumber].selected && setGame.cards[cardNumber].matched {
            return false
        } else {
            return true
        }
    }
    
    private func updateViewFromModel(){
        updateScore()
        checkDeal3MoreCardsStatus()
        for index in 0..<cardButtons.count{
            let button = cardButtons[index]
            if index < setGame.qtdCardsGame {
                if index < setGame.cards.count {
                    let card = setGame.cards[index]
                    let attributes = getAttibutes(card)
                    let text = getText(card)
                    let attibutedString = NSAttributedString(string: text, attributes: attributes)
                    button.setAttributedTitle(attibutedString, for: UIControl.State.normal)
                    button.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
                    if card.selected {
                        if card.matched {
                            if card.hided {
                                hideButton(button)
                                makeBorder(BorderType.none, button)
                            } else {
                                makeBorder(BorderType.matched, button)
                            }
                        } else if card.mismatched {
                            makeBorder(BorderType.mismatched, button)
                        } else {
                            makeBorder(BorderType.selected, button)
                        }
                    } else {
                        makeBorder(BorderType.none, button)
                    }
                } else {
                    hideButton(button)
                    makeBorder(BorderType.none, button)
                }
            } else {
                hideButton(button)
                makeBorder(BorderType.none, button)
            }
        }
    }
    
    private func checkDeal3MoreCardsStatus() {
        if setGame.cards.count <= setGame.qtdCardsGame {
            deal3MoreCardsButton.isEnabled = false
        } else if setGame.qtdCardsGame == cardButtons.count && setGame.hasMatch == false {
            deal3MoreCardsButton.isEnabled = false
        } else {
            deal3MoreCardsButton.isEnabled = true
        }
    }
    
    private func makeBorder(_ type: BorderType, _ button: UIButton){
        switch type {
        case .selected:
            button.layer.borderWidth = 3.0
            button.layer.borderColor = UIColor.blue.cgColor
        case .matched:
            button.layer.borderWidth = 5.0
            button.layer.borderColor = UIColor.green.cgColor
        case .mismatched:
            button.layer.borderWidth = 5.0
            button.layer.borderColor = UIColor.red.cgColor
        case .none:
            button.layer.borderWidth = 0.0
            button.layer.borderColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
        }
    }
    
    private func hideButton(_ button: UIButton){
        button.setAttributedTitle(nil, for: UIControl.State.normal)
        button.backgroundColor = #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 0)
    }
    
    private func updateScore(){
        scoreLabel.text = "Score: \(setGame.score) "
        updateScoreColor()
    }
    
    private func updateScoreColor(){
        if scoreLabel.textColor == UIColor.black {
            scoreLabel.textColor = UIColor.white
        } else if scoreLabel.textColor == UIColor.white {
            scoreLabel.textColor = UIColor.red
        } else if scoreLabel.textColor == UIColor.red {
            scoreLabel.textColor = UIColor.black
        }
    }
    
    private func getAttibutes(_ card: Card) -> [NSAttributedString.Key:Any] {
        var attributes: [NSAttributedString.Key:Any] = [:]
        let color = getColor(card)
        switch card.shading {
        case .filled:
            attributes = [
                .strokeWidth : -5.0,
                .font : UIFont.systemFont(ofSize: 28),
                .foregroundColor : color.withAlphaComponent(100.0)
            ]
        case .outline:
            attributes = [
                .strokeWidth : 10.0,
                .font : UIFont.systemFont(ofSize: 28),
                .foregroundColor : color
            ]
        case .striped:
            attributes = [
                .strokeWidth : 0.0,
                .font : UIFont.systemFont(ofSize: 28),
                .foregroundColor : color.withAlphaComponent(0.15)
            ]
        }
        return attributes
    }
    
    private func getColor(_ card: Card) -> UIColor {
        switch card.color {
        case .red:
            return UIColor.red
        case .green:
            return UIColor.green
        case .purple:
            return UIColor.purple
        }
    }
    
    private func getText(_ card: Card) -> String{
        var text = ""
        for _ in 0..<card.numberOfShapes.rawValue {
            text += card.shape.description
        }
        return text
    }
}

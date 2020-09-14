//
//  SetCardViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 01/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetCardViewController: UIViewController {
    
    private var game = SetGame()
    
    @IBOutlet weak var setBoardView: SetBoardView!{
        didSet {
            let swipe = UISwipeGestureRecognizer(target: self, action: #selector(deal3))
            
            swipe.direction = .down
            setBoardView.addGestureRecognizer(swipe)
            
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reshuffle))
            setBoardView.addGestureRecognizer(rotate)
        }
    }
    
    @IBOutlet weak var deckCountLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var hintButton: BorderButton!
    @IBOutlet weak var dealButton: BorderButton!
    @IBOutlet weak var newButton: BorderButton!
    
    private weak var timer: Timer?
    private var lastHint = 0
    private let flashTime = 1.5
    
    @IBAction func hint() {
        timer?.invalidate()
        if game.hints.count > 0 {
            game.hints[lastHint].forEach{ (idx) in
                setBoardView.cardViews[idx].hint()
            }
            messageLabel.text = "Set \(lastHint + 1) Wait..."
            timer = Timer.scheduledTimer(withTimeInterval: flashTime, repeats: false) { [weak self] time in
                self?.lastHint = (self?.lastHint)!.incrementCicle(in: (self?.game.hints.count)!)
                self?.messageLabel.text = ""
                self?.updateCardViewsFromModel()
            }
        }
    }
    
    @IBAction func deal3() {
        game.deal3()
        updateViewFromModel()
    }
    
    @IBAction func new() {
        game = SetGame()
        setBoardView.cardViews.removeAll()
        updateViewFromModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    @objc
    func reshuffle(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default:
            break
        }
    }
    
    private func updateViewFromModel(){
        updateCardViewsFromModel()
        updateHintButton()
        deckCountLabel.text = "Deck: \(game.deckCount)"
        scoreLabel.text = "Score: \(game.score) / \(game.numberSets)"
        if let itIsSet = game.isSet {
            messageLabel.text = itIsSet ? "Match": "Mismatch"
        } else {
            messageLabel.text = ""
        }
        
        dealButton.isHidden = game.deckCount == 0
        hintButton.disable = game.hints.count == 0
    }
    
    private func updateHintButton() {
        hintButton.setTitle("\(game.hints.count) sets", for: .normal)
        lastHint = 0
    }
    
    private func updateCardViewsFromModel(){
        if setBoardView.cardViews.count - game.cardsOnTable.count > 0 {
            let cardViews = setBoardView.cardViews[..<game.cardsOnTable.count]
            setBoardView.cardViews = Array(cardViews)
        }
        let numberCardViews = setBoardView.cardViews.count
        
        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            if index > (numberCardViews - 1) {
                let cardView = SetCardView()
                updateCardView(cardView, for: card)
                addTapGestureRecognizer(for: cardView)
                setBoardView.cardViews.append(cardView)
            } else {
                let cardView = setBoardView.cardViews[index]
                updateCardView(cardView, for: card)
            }
        }
    }
    
    private func addTapGestureRecognizer(for cardView: SetCardView) {
        let tap = UITapGestureRecognizer(target: self, action: #selector(tapCard(recognizedBy:)))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        cardView.addGestureRecognizer(tap)
    }
    
    @objc
    private func tapCard(recognizedBy recognizer: UITapGestureRecognizer){
        switch recognizer.state {
        case .ended:
            if let cardView = recognizer.view! as? SetCardView {
                game.chooseCard(at: setBoardView.cardViews.index(of: cardView)!)
            }
        default:
            break
        }
        updateViewFromModel()
    }
    
    private func updateCardView(_ cardView: SetCardView, for card: SetCard){
        cardView.symbolInt = card.shape.rawValue
        cardView.fillInt = card.fill.rawValue
        cardView.colorInt = card.color.rawValue
        cardView.count = card.number.rawValue
        cardView.isSelected = game.cardsSelected.contains(card)
        if let itIsSet = game.isSet {
            if game.cardsTryMatched.contains(card) {
                cardView.isMatched = itIsSet
            }
        } else {
            cardView.isMatched = nil
        }
    }
}

extension Int {
    func incrementCicle(in number: Int) -> Int {
        return (number - 1) > self ? self + 1:0
    }
}

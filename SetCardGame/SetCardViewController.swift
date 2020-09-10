//
//  SetCardViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 01/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetCardViewController: UIViewController {
    
    private var game = Set()
    
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
    
    @IBOutlet weak var hintButton: UIButton!
    @IBOutlet weak var dealButton: UIButton!
    @IBOutlet weak var newButton: UIButton!
    
    private weak var timer: Timer?
    private var lastHint = 0
    private let flashTime = 1.5
    
    @IBAction func hint() {
    }
    
    @IBAction func deal3() {
    }
    
    @IBAction func new() {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateViewFromModel()
    }
    
    @objc
    func reshuffle(_ sender: UIRotationGestureRecognizer) {
        switch sender.state {
        case .ended:
            game.shuffleCards()
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
//        hintButton.disable = game.hints.count == 0
    }
    
    private func updateHintButton() {
        
    }
    
    private func updateCardViewsFromModel(){
        
    }
    
    private func addTapGestureRecognizer(for cardView: SetCardView) {
        
    }
    
    @objc
    private func tapCard(recognizedBy recognizer: UITapGestureRecognizer){
        
    }
    
    private func updateCardView(_ cardView: SetCardView, for card: Card){
        
    }
}

extension Int {
    func incrementCicle(in number: Int) -> Int {
        return (number - 1) > self ? self + 1:0
    }
}

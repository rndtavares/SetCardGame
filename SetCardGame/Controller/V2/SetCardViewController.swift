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
            let rotate = UIRotationGestureRecognizer(target: self, action: #selector(reshuffle))
            setBoardView.addGestureRecognizer(rotate)
        }
    }
    
    @IBOutlet weak var setsButton: UIButton!
    
    @IBOutlet weak var deckImageView: DeckImageView!{
        didSet {
            let tap = UITapGestureRecognizer(target: self, action: #selector(deal3))
            tap.numberOfTapsRequired = 1
            tap.numberOfTouchesRequired = 1
            deckImageView.addGestureRecognizer(tap)
        }
    }
    
    @IBOutlet weak var newButton: BorderButton!
    @IBOutlet weak var hintButton: BorderButton!
    
    @IBOutlet weak var stackMessage: UIStackView!
    
    lazy var animator = UIDynamicAnimator(referenceView: view)
    lazy var cardBehavior = CardBehavior(in: animator)
    
    private var deckCenter: CGPoint {
        return view.convert(stackMessage.center, to: setBoardView)
    }
    
    private var discardPileCenter: CGPoint {
        return stackMessage.convert(setsButton.center, to: setBoardView)
    }
    
    private var matchedSetCardViews: [SetCardView]{
        return setBoardView.cardViews.filter {$0.isMatched == true}
    }
    
    private var dealSetCardViews: [SetCardView] {
        return setBoardView.cardViews.filter { $0.alpha == 0}
    }
    
    private var tmpCards = [SetCardView]()
    
    private func updateViewFromModel(){
        updateCardViewsFromModel()
        deckImageView.deckNumberString = "\(game.deckCount)"
        setsButton.setTitle("Sets: \(game.numberSets)", for: .normal)
        setsButton.alpha = (game.numberSets == 0) || (game.isSet != nil && game.isSet!) ? 0 : 1
        hintButton.setTitle(" \(game.hints.count) sets", for: .normal)
        lastHint = 0
    }
    
    private func updateCardViewsFromModel(){
        var newCardViews = [SetCardView]()
        
        if setBoardView.cardViews.count - game.cardsOnTable.count > 0 {
            setBoardView.removeCardViews(removeCardViews: matchedSetCardViews)
        }

        let numberCardViews = setBoardView.cardViews.count
        
        for index in game.cardsOnTable.indices {
            let card = game.cardsOnTable[index]
            if index > (numberCardViews - 1) {
                let cardView = SetCardView()
                updateCardView(cardView, for: card)
                cardView.alpha = 0
                addTapGestureRecognizer(for: cardView)
                newCardViews += [cardView]
            } else {
                let cardView = setBoardView.cardViews[index]
                if cardView.alpha < 1 && cardView.alpha > 0 && game.isSet != true {
                    cardView.alpha = 0
                }
                updateCardView(cardView, for: card)
            }
        }
        setBoardView.addCardViews(newCardViews: newCardViews)
        
        flyAwayAnimation()
        
        dealAnimation()
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
    
    
    private func flyAwayAnimation() {
        
        let alreadyFliedCount = matchedSetCardViews.filter {($0.alpha < 1 && $0.alpha > 0)}.count
        if game.isSet != nil, game.isSet!, alreadyFliedCount == 0 {
            tmpCards.forEach { tmpCard in
                tmpCard.removeFromSuperview()
            }
            tmpCards = []
            
            matchedSetCardViews.forEach { setCardView in
                setCardView.alpha = 0.2
                tmpCards += [setCardView.copyCard()]
            }
            
            tmpCards.forEach { tmpCard in
                setBoardView.addSubview(tmpCard)
                cardBehavior.addItem(tmpCard)
            }
            
            tmpCards[0].addDiscardPile = { [weak self] in
                if let countSets = self?.game.numberSets, countSets > 0 {
                    self?.setsButton.alpha = 0
                }
            }
            
            tmpCards[2].addDiscardPile = { [weak self] in
                if let countSets = self?.game.numberSets, countSets > 0 {
                    self?.setsButton.setTitle(" Sets: \(countSets) ", for: .normal)
                    self?.setsButton.alpha = 1
                }
            }
            
            Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { (timer) in
                var delayInterval = 1
                for tmpCard in self.tmpCards {
                    self.cardBehavior.removeItem(tmpCard)
                    tmpCard.animatedFly(to: self.discardPileCenter, delay: TimeInterval(delayInterval) * 0.25)
                    delayInterval += 1
                }
            }
        }
    }
    
    private func dealAnimation(){
        var currentDealCard = 0
        
        let timeInterval = 0.15 * Double(setBoardView.rowsGrid + 1)
        Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) {
            (timer) in
            for cardView in self.dealSetCardViews {
                cardView.animateDeal(from: self.deckCenter, delay: TimeInterval(currentDealCard) * 0.25)
                currentDealCard += 1
            }
        }
    }
    
    private weak var timer: Timer?
    private var lastHint = 0
    private let flashTime = 1.5
    
    @IBAction func hint() {
        timer?.invalidate()
        if game.hints.count > 0 {
            game.hints[lastHint].forEach{ (idx) in
                setBoardView.cardViews[idx].hint()
            }
            timer = Timer.scheduledTimer(withTimeInterval: flashTime, repeats: false) { [weak self] time in
                self?.lastHint = (self?.lastHint)!.incrementCicle(in: (self?.game.hints.count)!)
                self?.updateCardViewsFromModel()
            }
        }
    }
    
    @IBAction func new() {
        game = SetGame()
        setBoardView.resetCards()
        tmpCards.forEach { (tmpCard) in tmpCard.removeFromSuperview() }
        tmpCards = []
        updateViewFromModel()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateViewFromModel()
    }
    
    @objc
    func deal3() {
        game.deal3()
        updateViewFromModel()
    }
    
    @objc
    func reshuffle(_ sender: UIRotationGestureRecognizer) {
        guard sender.view != nil else {return}
        switch sender.state {
        case .ended:
            game.shuffle()
            updateViewFromModel()
        default:
            break
        }
    }
    
    private func updateHintButton() {
        hintButton.setTitle("\(game.hints.count) sets", for: .normal)
        lastHint = 0
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
}

extension Int {
    func incrementCicle(in number: Int) -> Int {
        return (number - 1) > self ? self + 1:0
    }
}

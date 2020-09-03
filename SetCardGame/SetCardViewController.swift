//
//  SetCardViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 01/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetCardViewController: UIViewController {
    
    @IBOutlet weak var setBoardView: SetBoardView!
    
    private var setGame = Set()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        for _ in 1...12 {
            if let card = setGame.draw() {
                let cardView = SetCardView()
                cardView.card = card
                setBoardView.cardViews.append(cardView)
            }
        }
    }
}

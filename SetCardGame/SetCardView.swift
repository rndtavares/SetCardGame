//
//  SetCardViewController.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 01/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetCardView: UIView {
    
    var gameCards : [Card] = [] { didSet { setNeedsDisplay(); setNeedsLayout() }}
    
    override func layoutSubviews() {
        super.layoutSubviews()
        print("more magic happening")
    }
    
    override func draw(_ rect: CGRect) {
        // Drawing code
        print("magic happening")
    }

}

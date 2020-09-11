//
//  SetBoardView.swift
//  SetCardGame
//
//  Created by Ronaldo Tavares da Silva on 03/09/2020.
//  Copyright © 2020 Ronaldo Tavares da Silva. All rights reserved.
//

import UIKit

class SetBoardView: UIView {

    var cardViews = [SetCardView]() {
        willSet { removeSubviews() }
        didSet { addSubviews(); setNeedsLayout() }
    }
    
    private func removeSubviews(){
        for cardView in cardViews {
            cardView.removeFromSuperview()
        }
    }
    
    private func addSubviews(){
        for cardView in cardViews {
            addSubview(cardView)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var grid = Grid(layout: Grid.Layout.aspectRatio(Constant.cellAspectRatio),
                        frame: bounds)
        grid.cellCount = cardViews.count
        for row in 0..<grid.dimensions.rowCount {
            for column in 0..<grid.dimensions.columnCount {
                let lastCard = row * grid.dimensions.columnCount + column
                if cardViews.count > lastCard {
                    cardViews[lastCard].frame = grid[row, column]!.insetBy(dx: Constant.spacingDx, dy: Constant.spacingDy)
                }
            }
        }
        
    }
    
    struct Constant {
        static let cellAspectRatio: CGFloat = 0.7
        static let spacingDx: CGFloat = 3.0
        static let spacingDy: CGFloat = 3.0
    }
}
